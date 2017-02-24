# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="geoffgarside"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias buildlib='gradlew assembleDebug && gradlew uploadArchives'
alias gitv='git show --abbrev-commit | grep commit'
alias shortlog='git log --decorate --oneline'
alias subu='git submodule sync --recursive && git submodule update --init --recursive'
alias tags='git for-each-ref --format="%(*committerdate:raw)%(committerdate:raw) %(refname:short)" refs/tags | sort -n'
alias br='git for-each-ref --format="%(*committerdate:raw)%(committerdate:raw) %(refname:short)" refs/heads | sort -n'
alias cob='git checkout -b'
alias arcprm='git branch | grep arcpatch- | xargs -I {} git branch -D {}'
alias pull='f() { git pull && git submodule sync --recursive && git submodule update --init --recursive; }; f'
alias pu=pull
alias pul=pull
alias opne=open
alias oepn=open
alias opnep=openp
alias oepnp=openp
alias pi='pod _0.39.0_ install && terminal-notifier -message "Pod install complete"'
alias grhh='git reset --hard HEAD'
alias cleanLocalPhabTags='git tag -l | grep "phabricator" | xargs git tag -d'
alias cleanRemotePhabTags='git pull origin master --tags && git tag -l | grep "phabricator" | awk '\''{print ":"$0}'\'' | xargs git push origin && git tag -l | xargs git tag -d && git pull origin master --tags'
alias helix='./apps/iphone-helix/script/bootstrap && open ./apps/iphone-helix/src/Rider.xcworkspace'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(battery bundler git github jira lol nyan osx rand-quote rails rails-api rake git-completion)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Custom snarky prompt + Git/source control right-hand prompt
#using https://github.com/olivierverdier/zsh-git-prompt
source ~/dotfiles/gitprompt.sh
precmd() {
    update_current_git_vars
}
PROMPT='C:%d>'
RPROMPT=$'$(git_super_status)'

# Custom additions to PATH var (git, Android tools, my dotfiles repo, rbenv)
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:$HOME/dotfiles:$HOME/.rbenv/bin:${HOME}/bin:$HOME/Library/Android/sdk/tools:$HOME/Library/Android/sdk/platform-tools
export ANDROID_HOME=$HOME/Library/Android/sdk
export EDITOR='subl'

# added by newengsetup
export EDITOR=vim
export UBER_HOME="$HOME/Uber"
export UBER_OWNER="daryll@uber.com"
export VAGRANT_DEFAULT_PROVIDER=aws
[ -s "/usr/local/bin/virtualenvwrapper.sh" ] && . /usr/local/bin/virtualenvwrapper.sh
[ -s "$HOME/.nvm/nvm.sh" ] && . $HOME/.nvm/nvm.sh
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

cdsync () {
    cd $(boxer sync_dir $@)
}

editsync () {
    $EDITOR $(boxer sync_dir $@)
}

opensync () {
    open $(boxer sync_dir $@)
}

function update(){
  git checkout master && pul && git checkout - && git rebase master
}

rdio() {
	if [ -n "$(grep -lr '# Rdio Testing' Podfile)" ] 
	then 
		return 
	fi
    perl -pi -e "s/(external-cocoapods-specs')/\$1\nsource 'https:\/\/github.com\/CocoaPods\/Specs.git'/" Podfile
    perl -pi -e "s/(target :'UberDriver' do)/\$1\n\n  # Rdio Testing\n  pod 'Rdio', :path => '.\/Vendor\/Rdio'\n  pod 'AFOAuth2Manager', '2.2.0'\n/" Podfile
    perl -pi -e "s/(target :'UberDriverTests' do)/\$1\n\n  # Rdio Testing\n  pod 'Rdio', :path => '.\/Vendor\/Rdio'\n  pod 'AFOAuth2Manager', '2.2.0'\n/" Podfile
    perl -pi -e "s/\/\/#define RDIO_FRAMEWORK_AVAILABLE 1/#define RDIO_FRAMEWORK_AVAILABLE 1/" UberDriver/UBHarmony.h
    pi
}

openp(){ 
    if test -n "$(find . -maxdepth 1 -name '*.xcworkspace' -print -quit)"
    then
      open *.xcworkspace -a Xcode.app
      return
    else
      if test -n "$(find . -maxdepth 1 -name '*.xcodeproj' -print -quit)"
      then
        open *.xcodeproj -a Xcode.app
        return  
      else
        echo "No Xcode project found"
      fi
    fi
  }