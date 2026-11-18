package main

import (
	"errors"
	"fmt"
	"io"
	"log"
	"os"

	"git-prune-gone-branches/internal/git"
	"git-prune-gone-branches/internal/hook"
	"git-prune-gone-branches/internal/prune"
	"git-prune-gone-branches/internal/record"
)

const logPrefix = "git-prune-gone-branches: "

var ErrUsage = errors.New("usage: git-prune-gone-branches <state>")

func main() {
	logger := log.New(os.Stderr, logPrefix, 0)
	// preparing・preparedで0以外を返すと参照の更新が中断されるため、失敗しても0で終了
	if err := run(os.Args[1:], os.Stdin, logger); err != nil {
		logger.Print(err)
	}
}

func run(args []string, stdin io.Reader, logger *log.Logger) error {
	input, err := io.ReadAll(stdin)
	if err != nil {
		return fmt.Errorf("read stdin: %v", err)
	}

	if len(args) != 1 {
		return ErrUsage
	}

	state, err := hook.ParseState(args[0])
	if err != nil {
		return err
	}

	updates, err := hook.ParseUpdates(string(input))
	if err != nil {
		return err
	}

	deletedRefs := hook.DeletedRemoteRefs(updates)
	// 参照の更新のたびに呼ばれるため、リモート追跡ブランチを削除しない更新ではgitを実行せずに終了
	if len(deletedRefs) == 0 {
		return nil
	}

	commonDir, err := git.CommonDir()
	if err != nil {
		return err
	}

	// packed-refsにある参照の削除はロック中に入れ子の更新として二重に通知されるため、ロック中は無視
	if git.IsPackedRefsLocked(commonDir) {
		return nil
	}

	store := record.NewStore(commonDir)
	switch state {
	case hook.StatePreparing:
		return prune.RecordLastCommits(store, deletedRefs)
	case hook.StatePrepared:
		return nil
	case hook.StateCommitted:
		return prune.DeleteGoneBranches(store, logger)
	case hook.StateAborted:
		return store.Clear()
	}
	return nil
}
