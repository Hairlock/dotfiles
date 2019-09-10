export VISUAL=nvim
export EDITOR="$VISUAL"
export MYVIMRC="/home/yannick/.config/nvim/init.vim"
export PATH=/home/yannick/scripts:/home/yannick/.local/bin:$PATH
export FZF_DEFAULT_COMMAND='find *'

alias v="nvim"
alias vim="nvim"
alias su="sudo -E"
alias fm="fff"
alias wifi="nmtui"
alias monitor="xrandr --output HDMI-2 --auto --right-of eDP-1"
alias single-monitor="xrandr -s 0"

# Edit config files
alias ss="maim -s | xclip -selection clipboard -t image/png"
alias sn="sudo nvim"
alias ec="sn /etc/nixos/configuration.nix"
alias eb="sn ~/.bashrc"
alias ep="sn ~/.profile"
alias ev="sn ~/.config/nvim/init.vim"
alias eg="sn ~/scripts/.ghci"
alias ei3="sn ~/.config/i3/config"

# System command shortcuts
alias sus="systemctl suspend"
alias hib="systemctl hibernate"

# Directory shortcuts
alias h="cd ~"
alias df="cd ~/.dotfiles"
alias p="cd ~/Projects"
alias fp="cd ~/Projects/fp-complete"

# Script execution
alias gp="gitpush.sh"

# Haskell
alias gh="ghcid --test \":main\""
alias ghci="ghci -ghci-script ~/scripts/.ghci"

alias sb="source ~/.profile && source ~/.bashrc"

alias ndg="sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +1"
alias nrb="sudo nixos-rebuild switch"

# Bash shell driver for 'go' (http://code.google.com/p/go-tool/).
function go {
    export GO_SHELL_SCRIPT=$HOME/.__tmp_go.sh
    python -m go $*
    if [ -f $GO_SHELL_SCRIPT ] ; then
        source $GO_SHELL_SCRIPT
    fi
    unset GO_SHELL_SCRIPT
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

