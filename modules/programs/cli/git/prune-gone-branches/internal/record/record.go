package record

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"maps"
	"os"
	"path/filepath"
)

const fileName = "prune-gone-branches.json"

// 削除するリモート追跡ブランチの名前と、削除する直前に指していたコミット
type LastCommits map[string]string

type Store struct {
	path string
}

var (
	ErrReadRecord  = errors.New("read record failed")
	ErrWriteRecord = errors.New("write record failed")
)

func NewStore(commonDir string) Store {
	return Store{path: filepath.Join(commonDir, fileName)}
}

func (s Store) Add(commits LastCommits) error {
	recorded, err := s.load()
	if err != nil {
		return err
	}
	maps.Copy(recorded, commits)
	content, err := json.Marshal(recorded)
	if err != nil {
		return fmt.Errorf("%w: %v", ErrWriteRecord, err)
	}
	if err := os.WriteFile(s.path, content, 0o600); err != nil {
		return fmt.Errorf("%w: %v", ErrWriteRecord, err)
	}
	return nil
}

func (s Store) Take() (LastCommits, error) {
	recorded, err := s.load()
	if err != nil {
		return nil, err
	}
	if err := s.Clear(); err != nil {
		return nil, err
	}
	return recorded, nil
}

func (s Store) Clear() error {
	err := os.Remove(s.path)
	if err != nil && !errors.Is(err, fs.ErrNotExist) {
		return fmt.Errorf("%w: %v", ErrWriteRecord, err)
	}
	return nil
}

func (s Store) load() (LastCommits, error) {
	content, err := os.ReadFile(s.path)
	if errors.Is(err, fs.ErrNotExist) {
		return LastCommits{}, nil
	}
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrReadRecord, err)
	}

	recorded := LastCommits{}
	if err := json.Unmarshal(content, &recorded); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrReadRecord, err)
	}
	return recorded, nil
}
