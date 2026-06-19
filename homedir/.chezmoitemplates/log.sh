# log: print apply progress to stderr. Each script runs as its own process,
# so it is expanded into the body via includeTemplate. Set STEP to the step
# name so each line shows which script is running. Colored only on a terminal.
log() {
  if [ -t 2 ]; then
    printf '\033[1;36m==>\033[0m [%s] %s\n' "${STEP:-chezmoi}" "$*" >&2
  else
    printf '==> [%s] %s\n' "${STEP:-chezmoi}" "$*" >&2
  fi
}
