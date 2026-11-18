package hook

import (
	"errors"
	"fmt"
	"strings"
)

const remoteRefPrefix = "refs/remotes/"

type State string

const (
	StatePreparing State = "preparing"
	StatePrepared  State = "prepared"
	StateCommitted State = "committed"
	StateAborted   State = "aborted"
)

type Update struct {
	OldValue string
	NewValue string
	RefName  string
}

var (
	ErrUnknownState    = errors.New("unknown reference transaction state")
	ErrMalformedUpdate = errors.New("malformed reference update")
)

func ParseState(arg string) (State, error) {
	state := State(arg)
	switch state {
	case StatePreparing, StatePrepared, StateCommitted, StateAborted:
		return state, nil
	}
	return "", fmt.Errorf("%w: %q", ErrUnknownState, arg)
}

func ParseUpdates(input string) ([]Update, error) {
	var updates []Update
	for line := range strings.Lines(input) {
		fields := strings.Fields(line)
		if len(fields) != 3 {
			return nil, fmt.Errorf("%w: %q", ErrMalformedUpdate, line)
		}
		updates = append(updates, Update{OldValue: fields[0], NewValue: fields[1], RefName: fields[2]})
	}
	return updates, nil
}

func DeletedRemoteRefs(updates []Update) []string {
	var refs []string
	for _, update := range updates {
		// 削除の通知では新しい値がすべて0のオブジェクト名
		isDeletion := strings.Trim(update.NewValue, "0") == ""
		if isDeletion && strings.HasPrefix(update.RefName, remoteRefPrefix) {
			refs = append(refs, update.RefName)
		}
	}
	return refs
}
