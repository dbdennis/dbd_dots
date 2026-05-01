# =========================
# OH-MY-ZSH CORE
# =========================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(vi-mode)
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

source $ZSH/oh-my-zsh.sh

# =========================
# PATH
# =========================

export PATH=$PATH:/usr/local/bin
export PATH="$HOME/Work/zettels/scripts:$PATH"

[ -d "$HOME/.linuxbrew/bin" ] && export PATH="$HOME/.linuxbrew/bin:$PATH"

# =========================
# PYTHON ENV
# =========================

[ -d "$HOME/zenv/bin" ] && export PATH="$HOME/zenv/bin:$PATH"

[ -f ~/zenv/bin/activate ] && source ~/zenv/bin/activate

# =========================
# ALIASES
# =========================

alias hocz="cd ~/Work/zettels/other-research"
alias docs="cd ~/Work/zettels/other-docs"
alias zettels="cd ~/Work/zettels"
alias scripts="builtin cd ~/Work/zettels/scripts"
alias sandbox="cd ~/Work/zettels/hocz/hoc-research/zettels-core-and-supp"
alias dots="cd ~/Work/dbd_dots"
alias humanitexts="cd ~/Work/humanitexts"
alias booksource="cd ~/Work/zettels/book-sphinx/source"
alias work="cd ~/Work"
alias choc="cd ~/Work/choc-zettels"

alias writing="cd ~/Work/dbd_zetteln/dbd-writing"
alias manuscript="cd ~/Work/german-history-codex/manuscript"
alias codex="cd ~/Work/german-history-codex"

alias todo="cd ~/Work/dbd_zetteln; ghi edit 3"
alias dbdlinux="ssh dbdlinux.local"

# =========================
# DISPLAY
# =========================

if grep -qi microsoft /proc/version 2>/dev/null; then
    unset DISPLAY
    export DISPLAY=:0
else
    export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
    export LIBGL_ALWAYS_REDIRECT=1
fi

# =========================
# TERMINAL SUPPORT
# =========================

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
   source /etc/profile.d/vte.sh
fi

# =========================
# SHELL OPTIONS
# =========================

setopt extendedglob

# =========================
# LOCAL (SECRETS, MACHINE-SPECIFIC)
# =========================

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# =========================
# FORCE THEME LAST (fix prompt override)
# =========================

source $ZSH/themes/robbyrussell.zsh-theme
