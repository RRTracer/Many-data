echo ""
echo "======================== Liste des Alias ================================"
echo "act            alert          aptitall       bad            brc"
echo "c              c.             egrep          fgrep          good"
echo "grep           ipa            l              la             ll"
echo "ls             p              py3            pyreq          qps"
echo "wifi          physique       tpcoens         repogit       systeme-ortega" 
echo "save(snapshot) sdoc           fg(fakelist)    badeti        hoarau"
echo "senez        mathinfo        blanchard       pro           ssdnoir"
echo "ssdrouge     pubdoc"
echo "=========================================================================="
echo ""



# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="agnoster"
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ipa='ip -br a | grep -vF DOWN | cut -d/ -f1'
alias aptitall='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt purge -y'
alias wifi='nmtui'
alias py3='virtualenv -p python3 .py3 && source .py3/bin/activate'
alias pyreq='pip install -r requirements.txt'
alias act="source .py*/bin/activate"
alias p='python3'
alias c='codium'
alias c.='codium .'
alias zrc='nano ~/.zshrc'
alias brc='nano .bashrc'
alias good='bash /home/rrtracer/.good.sh'
alias bad='bash /home/rrtracer/.bad.sh'
alias qps='gnome-system-monitor'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias fg='cat ~/nominatif/fakelist'

#alias de repertoire 
alias repogit='cd /home/rrtracer/nominatif/REPO_git'
alias systeme-ortega='cd /home/rrtracer/nominatif/BTS2/système/Systeme-ortega'
alias badeti='cd /home/rrtracer/nominatif/BTS2/réseau/reseaux_prof2'
alias hoarau='cd /home/rrtracer/nominatif/BTS2/réseau/hoarau'
alias senez='cd /home/rrtracer/nominatif/BTS2/réseau/Reseaux_senez'
alias mathinfo='cd /home/rrtracer/nominatif/BTS2/maths_info'
alias blanchard='cd /home/rrtracer/nominatif/BTS2/blanchard'
alias pro='cd /home/rrtracer/nominatif/OFF/LM_CYR_PRO'
alias ssdnoire='cd /media/rrtracer/CRYP879ENWT/'
alias ssdrouge='cd /media/rrtracer/My\ Passeport'
# alias pour les répo physique
alias physique='cd /home/rrtracer/nominatif/BTS2/physique'
alias tpcoens='cd /home/rrtracer/nominatif/BTS2/physique/physique_tp/coens'

#alias de sauvegarde de mes snapshot de mon os .
alias save='sudo timeshift --create --comments "Snapshot manuel" --tags D --snapshot-device /media/rrtracer/My\ Passport/snapshot_os/'

# alias de sauvegarde document nominatif dans le  CRYP879ENWT
alias sdoc='tar -czvf /media/rrtracer/CRYP879ENWT/nominatif.tar.gz nominatif'
#alias de sauvegarde docmment nonnominatif dans le My Passport
alias pubdoc='tar -czvf /media/rrtracer/My\ Passport/nonnominatif.tar.gz nonnominatif'
alias bashscript='cd /home/rrtracer/nominatif/REPO_git/Bash-scripting-lesson'
