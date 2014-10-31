function peco-search-document() {
  local pos=$CURSOR
  local DOCUMENT_DIR
  DOCUMENT_DIR=($HOME/Dropbox)
  if [ -d $HOME/Documents ]; then
    DOCUMENT_DIR=($HOME/Documents $DOCUMENT_DIR)
  fi
  local SELECTED_FILE=$(echo $DOCUMENT_DIR | \
    xargs find | \
    grep -E "\.(txt|md|pdf|key|numbers|pages|docx?|xlsx?|pptx?)$" | \
    peco --query="$LBUFFER")
  if [ x"$SELECTED_FILE" != x ]; then
    BUFFER="${BUFFER[1,$pos]}$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
    CURSOR=$#BUFFER
    zle -R -c
  fi
}
zle -N peco-search-document
