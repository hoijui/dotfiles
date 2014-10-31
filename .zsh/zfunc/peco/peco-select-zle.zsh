function peco-select-zle() {
  # local widgets=$(zle -l | peco --query "$LBUFFER" | awk '{print $1}')
  # local widgets=$(zle -l | grep -v _zsh_highlight | grep -v orig- | peco | awk '{print $1}')
  local widgets=$(zle -l | grep -ve '^_\|zsh_highlight\|^orig-' | peco | awk '{print $1}')
  if [ -n "$widgets" ]; then
    zle $widgets
  fi
}

zle -N peco-select-zle
