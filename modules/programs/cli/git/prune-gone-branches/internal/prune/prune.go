package prune

import (
	"fmt"
	"log"
	"strings"

	"git-prune-gone-branches/internal/git"
	"git-prune-gone-branches/internal/record"
)

const remoteRefPrefix = "refs/remotes/"

// 削除の確定後はリモート追跡ブランチが指していたコミットを読めないため、preparingの段階で記録
func RecordLastCommits(store record.Store, deletedRefs []string) error {
	currentCommits, err := git.RemoteRefCommits()
	if err != nil {
		return err
	}

	lastCommits := record.LastCommits{}
	for _, ref := range deletedRefs {
		if commit, ok := currentCommits[ref]; ok {
			lastCommits[ref] = commit
		}
	}
	if len(lastCommits) == 0 {
		return nil
	}
	return store.Add(lastCommits)
}

func DeleteGoneBranches(store record.Store, logger *log.Logger) error {
	lastCommits, err := store.Take()
	if err != nil {
		return err
	}

	currentCommits, err := git.RemoteRefCommits()
	if err != nil {
		return err
	}

	// pack-refsも参照の削除として通知されるため、削除の確定後も存在する参照を削除の対象から除外
	for ref := range currentCommits {
		delete(lastCommits, ref)
	}
	if len(lastCommits) == 0 {
		return nil
	}

	branches, err := git.LocalBranches()
	if err != nil {
		return err
	}

	for _, branch := range branches {
		lastCommit, ok := lastCommits[branch.Upstream]
		if !ok {
			continue
		}
		if branch.WorktreePath != "" {
			logger.Printf("kept %s: it is checked out in %s", branch.Name, branch.WorktreePath)
			continue
		}
		// 手元にしかないコミットを失わないよう、上流の最後のコミットに含まれるブランチだけを削除
		isPushed, err := git.IsAncestor(branch.Name, lastCommit)
		if err != nil {
			logger.Print(err)
			continue
		}

		if !isPushed {
			logger.Printf("kept %s: it has commits not in %s", branch.Name, strings.TrimPrefix(branch.Upstream, remoteRefPrefix))
			continue
		}
		message, err := git.DeleteBranch(branch.Name)
		if err != nil {
			logger.Print(err)
			continue
		}

		fmt.Fprint(logger.Writer(), message)
	}
	return nil
}
