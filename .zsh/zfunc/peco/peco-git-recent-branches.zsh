function peco-git-recent-branches () {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | \
        perl -pne 's{^refs/heads/}{}' | \
        peco --query "$LBUFFER")
    if [ -n "$selected_branch" ]; then
        LBUFFER="git checkout ${selected_branch}"
    fi
}
zle -N peco-git-recent-branches
