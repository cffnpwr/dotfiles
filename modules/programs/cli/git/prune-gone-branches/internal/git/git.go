package git

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const packedRefsLockFileName = "packed-refs.lock"

type LocalBranch struct {
	Name     string
	Upstream string
	// チェックアウトしているworktreeのパスで、チェックアウトしていなければ空文字列
	WorktreePath string
}

var ErrUnexpectedOutput = errors.New("unexpected git output")

type CommandError struct {
	Args   []string
	Stderr string
	Err    error
}

func (e *CommandError) Error() string {
	return fmt.Sprintf("git %s: %v: %s", strings.Join(e.Args, " "), e.Err, strings.TrimSpace(e.Stderr))
}

func (e *CommandError) Unwrap() error {
	return e.Err
}

func CommonDir() (string, error) {
	output, err := run("rev-parse", "--git-common-dir")
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(output), nil
}

func IsPackedRefsLocked(commonDir string) bool {
	_, err := os.Stat(filepath.Join(commonDir, packedRefsLockFileName))
	return err == nil
}

func RemoteRefCommits() (map[string]string, error) {
	output, err := run("for-each-ref", "--format=%(refname)%00%(objectname)", "refs/remotes")
	if err != nil {
		return nil, err
	}
	commits := map[string]string{}
	for line := range strings.Lines(output) {
		name, commit, found := strings.Cut(strings.TrimSuffix(line, "\n"), "\x00")
		if !found {
			return nil, fmt.Errorf("%w: %q", ErrUnexpectedOutput, line)
		}
		commits[name] = commit
	}
	return commits, nil
}

func LocalBranches() ([]LocalBranch, error) {
	output, err := run("for-each-ref", "--format=%(refname:lstrip=2)%00%(upstream)%00%(worktreepath)", "refs/heads")
	if err != nil {
		return nil, err
	}
	var branches []LocalBranch
	for line := range strings.Lines(output) {
		fields := strings.Split(strings.TrimSuffix(line, "\n"), "\x00")
		if len(fields) != 3 {
			return nil, fmt.Errorf("%w: %q", ErrUnexpectedOutput, line)
		}
		branches = append(branches, LocalBranch{Name: fields[0], Upstream: fields[1], WorktreePath: fields[2]})
	}
	return branches, nil
}

func IsAncestor(branch string, commit string) (bool, error) {
	_, err := run("merge-base", "--is-ancestor", "refs/heads/"+branch, commit)
	// git merge-base --is-ancestorは祖先でない場合の終了ステータスが1
	if exitErr, ok := errors.AsType[*exec.ExitError](err); ok && exitErr.ExitCode() == 1 {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return true, nil
}

func DeleteBranch(name string) (string, error) {
	return run("branch", "-D", name)
}

func run(args ...string) (string, error) {
	command := exec.Command("git", args...)
	var stdout, stderr bytes.Buffer
	command.Stdout = &stdout
	command.Stderr = &stderr
	if err := command.Run(); err != nil {
		return "", &CommandError{Args: args, Stderr: stderr.String(), Err: err}
	}
	return stdout.String(), nil
}
