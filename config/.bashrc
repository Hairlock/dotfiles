export VISUAL=nvim
export EDITOR="$VISUAL"
export TERMINAL=st
export BROWSER=chromium
export MYVIMRC="/home/yannick/.config/nvim/init.vim"
export PATH=/home/yannick/scripts:/home/yannick/.local/bin:$PATH
export FZF_DEFAULT_COMMAND='find *'

# Program shortcuts
alias v="nvim"
alias vim="nvim"
alias fm="fff"
alias img="sxiv -t ."

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
alias su="sudo -E"
alias sus="systemctl suspend"
alias hib="systemctl hibernate"
alias wifi="nmtui"
alias monitor="xrandr --output HDMI-2 --auto --right-of eDP-1"
alias single-monitor="xrandr -s 0"
alias ndg="sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +1"
alias nrb="sudo nixos-rebuild switch"

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

# Misc
alias sb="source ~/.profile && source ~/.bashrc"
alias gs="git status"
