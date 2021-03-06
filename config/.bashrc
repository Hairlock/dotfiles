export VISUAL=nvim
export EDITOR="$VISUAL"
export TERMINAL=st
export BROWSER=chromium
export MYVIMRC="/home/yannick/.config/nvim/init.vim"
export PATH=/home/yannick/scripts:/home/yannick/.local/bin:$PATH
export FZF_DEFAULT_COMMAND='ag -l'

# FFF variable config
export FFF_HIDDEN=0

export FFF_FAV1=~/Projects
export FFF_FAV2=~/.dotfiles
export PROMPT_COMMAND="pwd > /tmp/whereami"

# Program shortcuts
alias vim="nvim"
alias fm="fff"
alias img="sxiv -t ."
alias cat="bat"
alias ns="nix-store"

# Edit config files
alias ss="maim -s | xclip -selection clipboard -t image/png"
alias sn="sudo nvim"
alias ec="sn /etc/nixos/configuration.nix"
alias eb="nvim ~/.bashrc"
alias ep="nvim ~/.profile"
alias ev="nvim ~/.dotfiles/config/.config/nvim/init.vim"
alias eg="nvim ~/scripts/.ghci"
alias ex="nvim ~/.config/sxhkd/sxhkdrc"
alias es="nvim ~/.config/i3status/config"
alias ei3="nvim ~/.config/i3/config"
alias et="nvim ~/todo.txt"
alias xk="xkeywatch"

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
alias r="cd ~/Repos"
alias fp="cd ~/Projects/fp-complete"
alias sk="cd ~/Repos/sked-v2/api"
alias v="cd ~/Videos"
alias m="cd ~/Videos/Movies"
alias f="cd ~/Documents/French"

# Script execution
alias gp="gitpush.sh"

# Haskell
alias gh="ghcid --test \":main\""
alias ghci="ghci -ghci-script ~/scripts/.ghci"

# Misc
alias sb="source ~/.bashrc"
alias gs="git status"

eval "$( direnv hook bash )"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
