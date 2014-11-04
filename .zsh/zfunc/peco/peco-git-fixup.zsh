peco-git-fixup() {
  if git rev-parse >/dev/null 2>&1; then
    local commit_hash=$(git log --oneline | peco | cut -d " " -f 1)
    if [ -n "$commit_hash" ]; then
      LBUFFER="git commit --fixup ${commit_hash}"
    fi
    zle -R -c
  fi
}
zle -N peco-git-fixup
