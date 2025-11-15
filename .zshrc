# Path to your oh-my-zsh installation.
export ZSH="/Users/filip/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
ZSH_ALIAS_FINDER_AUTOMATIC=true
plugins=(git alias-finder command-not-found docker-compose docker npm node rust sudo yarn fnm zsh-autosuggestions zsh-syntax-highlighting fzf)

# oh-my-zsh https://github.com/ohmyzsh/ohmyzsh
source $ZSH/oh-my-zsh.sh

# dump autocompletion in a cache directory
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# fnm https://github.com/Schniz/fnm
eval "$(fnm env)"

# broot https://github.com/Canop/broot
source /Users/filip/.config/broot/launcher/bash/br

# pnpm
export PNPM_HOME="/Users/filip/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
