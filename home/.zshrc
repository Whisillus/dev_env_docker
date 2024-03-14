
# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/root/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# whisillus begin

PROMPT="%F{yellow}%n%f @ %B%F{cyan}%~%f%b: "
RPROMPT="%F{white}%T%f"

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/autojump/autojump.zsh

export EDITOR='nvim'

alias vim="nvim"

alias lg='lazygit'
alias ga='git add'
alias gb='git branch'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gd='git diff'
alias gl='git log'
alias glg='git log --graph --abbrev-commit --oneline'
alias glga='git log --graph --abbrev-commit --oneline --all'
alias gs='git status'
alias gsw='git switch'

alias cmb='cmake --build build -j$(nproc)'
alias cmm='cmake -B build'
alias cmn='cmake -B build -G Ninja'
alias cmt='cmake -E chdir "build" ctest'

alias s='ls -h --color --group-directories-first'
alias l='ls -alh --color --group-directories-first'
alias p='python3'
alias v='nvim'

# whisillus end

