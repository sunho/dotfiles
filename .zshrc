# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.

fpath+=("$(brew --prefix)/share/zsh/site-functions")

autoload -U promptinit; promptinit
prompt pure

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git fzf z zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias vimdiff='nvim -d'
export EDITOR=nvim

# k1=\EOP
# k2=\EOQ
# k3=\EOR
# k4=\EOS
# k5=\E[15~
# k6=\E[17~
# k7=\E[18~
# k8=\E[19~
# k9=\E[20~

bindkey -s '\EOP' 'vim .^M'
bindkey -s '\EOQ' 'vifm .^M'

export PATH="$PATH:$HOME/arcanist/bin/"
alias python=python3

# pnpm
export PNPM_HOME="/Users/sunho/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end