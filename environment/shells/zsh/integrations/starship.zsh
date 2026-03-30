


precmd() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
        export GIT_BRANCH=" $(echo $branch | cut -c1-4) "
        unset GIT_SPACER
    else
        export GIT_SPACER=" "
        unset GIT_BRANCH
    fi
}

eval "$(starship init zsh)"
