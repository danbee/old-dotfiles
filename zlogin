# gets whether git is currently dirty
git_dirty() {
  git diff --ignore-submodules --quiet
  if [[ $? == 1 ]]; then
    echo "⭑"
  else
    git diff --staged --ignore-submodules --quiet
    [[ $? == 1 ]] && echo "⭑"
  fi
}

# adds the current branch name in green
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo "%{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}%{$fg_bold[red]%}$(git_dirty)%{$reset_color%} "
  fi
}

# adds the current ruby version in yellow
ruby_version() {
  if (( $+commands[rbenv] )); then
    ver=$(rbenv version |cut -d " " -f 1)
    if [[ -n $ver ]]; then
      echo "%{$fg[red]%}${ver}%{$reset_color%}"
    fi
  fi
}

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# expand functions in the prompt
setopt promptsubst

# prompt
export PROMPT='$(git_prompt_info)${SSH_CONNECTION+"%{$fg[yellow]%}%n@%m%{$reset_color%}:"}%{$fg_bold[blue]%}%2c%{$reset_color%} %{$fg_bold[cyan]%}❯%{$reset_color%} '
export RPROMPT='$(ruby_version)'

# load thoughtbot/dotfiles scripts
export PATH="$HOME/.bin:$PATH"
