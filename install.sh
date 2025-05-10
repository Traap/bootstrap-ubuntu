#!/bin/bash
# {{{ Usefull URLs

# Useful documentation.
#   https://miktex.org/howto/install-miktex-unx
#   https://linuxize.com/post/how-to-install-ruby-on-debian-9/

# -------------------------------------------------------------------------- }}}
# {{{ Main function

main() {
  # Source configuration files.
  loadConfig

  # Update operating system.
  updateOS
  installDefaultPackages

  # Configure git
  configureGit

  # Install application software.
  installBashGitPrompt
  installHosts
  installProfile
  installResolvConf
  installWslConf

  installMikTeX
  installTexLive
  installXWindows
  installRbEnv
  installRubyBuild

  updateBashRc

  installRuby
  installRubyGems
  installRust
  installRustPrograms

  installGraphViz
  installJavaJre
  installMutt

  installDbeaver

  installTLDR

  # Setup symlinks.
  deleteSymLinks
  createSymLinks

  # Configure ssh
  stopWslAutogeneration
  installSshDir
  generateSshHostKey
  setSshPermissions

  # Personalize
  loadTmuxPlugins
  loadNeovimPlugins
  loadVimPlugins
}

# -------------------------------------------------------------------------- }}}
# {{{ Load configuraiton options.

loadConfig() {
  if [[ -f config ]]; then
    [[ $echoConfigFlag == true ]] && sudo cat config
    source config
  else
    echo "config not found."
    exit
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Update OS

updateOS() {
  if [[ $osUpdateFlag == true ]]; then
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install BashGitPrompt

installBashGitPrompt() {
  if [[ $gitBashPromptFlag == true ]]; then
    say 'Instgall bash-git-prompt.'
    rm -rf ~/.bash-git-prompt
    src=https://github.com/magicmonty/bash-git-prompt
    dst=~/.bash-git-prompt
    git clone "$src" "$dst"
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install Ruby

installRuby() {
  if [[ $rbenvFlag == true ]]; then

    rbenv init
    rbenv install $rubyVersion
    rbenv global $rubyVersion

    echo "Ruby installed."
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install Ruby Gems

installRubyGems() {
  if [[ $rbenvFlag == true ]]; then

    # Install Ruby Gems
    gem install \
        bundler \
        rake \
        rspec

    echo "Ruby Gems installed."
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install Rust

installRust() {
  if [[ $rustFlag == true ]]; then

    echo "Install rust from a subshell."
    (
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    )

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install RustPrograms

installRustPrograms() {
  if [[ $rustProgramsFlag == true ]]; then

    cargo install exa

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install Mutt

installMutt() {
  if [[ $muttFlag == true ]]; then

    sudo apt-get install -y \
         neomutt \
         curl \
         isync \
         msmtp \
         pass

    git clone https://github.com/LukeSmithxyz/mutt-wizard

    cd mutt-wizard

    sudo make install

    echo "neomutt and mutt-wizzard are installed."
    echo "You must run the mutt-wizzard manually."

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install GraphViz

installGraphViz() {
  if [[ $graphVizFlag == true ]]; then

    sudo apt-get install -y \
      graphviz

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install JavaJre

installJavaJre() {
  if [[ $javaJreFlag == true ]]; then
    sudo apt-get install -y default-jdk
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install dbeaver

installDbeaver() {
  if [[ $dbeaverFlag == true ]]; then

    # default jdk
    sudo apt-get install -y default-jdk

    # debian repository.
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key \
         | sudo apt-key add -

    echo "deb https://dbeaver.io/debs/dbeaver-ce /" \
         | sudo tee /etc/apt/sources.list.d/dbeaver.list

    sudo apt update -y

    sudo apt-get install -y dbeaver-ce

    sudo apt policy -y dbeaver-ce
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install TLDR

installTLDR() {
  if [[ $tldrFlag == true ]]; then

    sudo npm install -g tldr

    tldr --update

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install my default packages.

installDefaultPackages() {
  if [[ $osUpdateFlag == true ]]; then
    sudo apt-get install -y \
                batcat \
                curl \
                dirmngr \
                exa \
                fdfind \
                fzf \
                gcc \
                git \
                golang \
                make \
                neovim \
                npm \
                python3-venv \
                ranger \
                ripgrep
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Configure git email and user.

configureGit() {
  if [[ $gitconfigFlag == true ]]; then
    git config --global user.email "$gitEmail"
    git config --global user.name "$gitName"
    git config --global credential.helper cache
    git config --global credential.helper 'cache --timeout=32000'
    git config --global core.editor vim
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Initialize .profile

installProfile() {
  if [[ $profileFlag == true ]]; then
    cp -v .profile $HOME/.
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Delete symbolic links

deleteSymLinks() {
  if [[ $deleteSymLinksFlag == 1 ]]; then
    echo "Deleting symbolic links."

    # Symlinks at .config
    rm -rfv ~/.config/Thunar
    rm -rfv ~/.config/alacritty
    rm -rfv ~/.config/autostart
    rm -rfv ~/.config/bspwm
    rm -rfv ~/.config/dconf
    rm -rfv ~/.config/dunst
    rm -rfv ~/.config/foot
    rm -rfv ~/.config/ghostty
    rm -rfv ~/.config/hypr
    rm -rfv ~/.config/kitty
    rm -rfv ~/.config/nvim
    rm -rfv ~/.config/neofetch
    rm -rfv ~/.config/picom
    rm -rfv ~/.config/polybar
    rm -rfv ~/.config/remmina
    rm -rfv ~/.config/rofi
    rm -rfv ~/.config/screenkey.json
    rm -rfv ~/.config/sxhkd
    rm -rfv ~/.config/volumeicon
    rm -rfv ~/.config/wallpaper
    rm -rfv ~/.config/waybar
    rm -rfv ~/.config/wayfire
    rm -rfv ~/.config/wayfire.ini
    rm -rfv ~/.config/wezterm
    rm -rfv ~/.config/wlogout
    rm -rfv ~/.config/wofi
    rm -rfv ~/.config/wofifull
    rm -rfv ~/.config/swaylock

    # Symlinks at $HOME
    rm -rfv ~/.bash_logout
    rm -rfv ~/.bash_profile
    rm -rfv ~/.bashrc
    rm -rfv ~/.bashrc_personal
    rm -rfv ~/.config.vim
    rm -rfv ~/.dircolors
    rm -rfv ~/.gitconfig
    rm -rfv ~/.gitignore_global
    rm -rfv ~/.inputrc
    rm -rfv ~/.latexmkrc
    # rm -rfv ~/.mailcap
    # rm -rfv ~/.muttrc
    rm -rfv ~/.ssh
    rm -rfv ~/.tmux
    rm -rfv ~/.tmux.conf
    rm -rfv ~/.vim
    rm -rfv ~/.vimrc
    rm -rfv ~/.xinitrc
    rm -rfv ~/.zshrc
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Create symbolic links
createSymLinks() {
  if [[ $createSymLinksFlag == 1 ]]; then
    echo "Creating symbolic links."
    mkdir -p ~/.config

    # Symlinks at .config
    ln -fsv ~/git/dotfiles/Thunar                ~/.config/Thunar
    ln -fsv ~/git/dotfiles/alacritty             ~/.config/alacritty
    ln -fsv ~/git/dotfiles/autostart             ~/.config/autostart
    ln -fsv ~/git/dotfiles/bspwm                 ~/.config/bspwm
    ln -fsv ~/git/dotfiles/dconf                 ~/.config/dconf
    ln -fsv ~/git/dotfiles/foot                  ~/.config/foot
    ln -fsv ~/git/dotfiles/dunst                 ~/.config/dunst
    ln -fsv ~/git/dotfiles/ghostty               ~/.config/ghostty
    ln -fsv ~/git/dotfiles/hypr                  ~/.config/hypr
    ln -fsv ~/git/dotfiles/kitty                 ~/.config/kitty
    ln -fsv ~/git/dotfiles/neofetch              ~/.config/neofetch
    ln -fsv ~/git/dotfiles/picom                 ~/.config/picom
    ln -fsv ~/git/dotfiles/polybar               ~/.config/polybar
    ln -fsv ~/git/dotfiles/remmina               ~/.config/remmina
    ln -fsv ~/git/dotfiles/rofi                  ~/.config/rofi
    ln -fsv ~/git/dotfiles/sk/screenkey.json     ~/.config/screenkey.json
    ln -fsv ~/git/dotfiles/sxhkd                 ~/.config/sxhkd
    ln -fsv ~/git/dotfiles/volumeicon            ~/.config/volumeicon
    ln -fsv ~/git/dotfiles/wallpaper             ~/.config/wallpaper
    ln -fsv ~/git/dotfiles/waybar                ~/.config/waybar
    ln -fsv ~/git/dotfiles/wayfire               ~/.config/wayfire
    ln -fsv ~/git/dotfiles/wayfire/wayfire.ini   ~/.config/wayfire.ini
    ln -fsv ~/git/dotfiles/wayfire/wf-shell.ini  ~/.config/wf-shell.ini
    ln -fsv ~/git/dotfiles/wezterm               ~/.config/wezterm
    ln -fsv ~/git/dotfiles/wlogout               ~/.config/wlogout
    ln -fsv ~/git/dotfiles/wofi                  ~/.config/wofi
    ln -fsv ~/git/dotfiles/wofifull              ~/.config/wofifull
    ln -fsv ~/git/dotfiles/swaylock              ~/.config/swaylock
    ln -fsv ~/git/nvim.traap                     ~/.config/nvim

    # Symlinks at $HOME
    ln -fsv ~/git/dotfiles/bash/bash_logout      ~/.bash_logout
    ln -fsv ~/git/dotfiles/bash/bash_profile     ~/.bash_profile
    ln -fsv ~/git/dotfiles/bash/bashrc           ~/.bashrc
    ln -fsv ~/git/dotfiles/bash/bashrc_personal  ~/.bashrc_personal
    ln -fsv ~/git/dotfiles/bash/dircolors        ~/.dircolors
    ln -fsv ~/git/dotfiles/bash/inputrc          ~/.inputrc
    ln -fsv ~/git/dotfiles/bash/xinitrc          ~/.xinitrc
    ln -fsv ~/git/dotfiles/git/gitconfig         ~/.gitconfig
    ln -fsv ~/git/dotfiles/git/gitignore_global  ~/.gitignore_global
    ln -fsv ~/git/dotfiles/latex/latexmkrc       ~/.latexmkrc
    # ln -fsv ~/git/mutt/mailcap                   ~/.mailcap
    # ln -fsv ~/git/mutt/muttrc                    ~/.muttrc
    ln -fsv ~/git/ssh                            ~/.ssh
    ln -fsv ~/git/ssh/config.vim                 ~/.config.vim
    ln -fsv ~/git/tmux                           ~/.tmux
    ln -fsv ~/git/tmux/tmux.conf                 ~/.tmux.conf
    ln -fsv ~/git/vim                            ~/.vim
    ln -fsv ~/git/vim/vimrc                      ~/.vimrc
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ MiKTeX

installMikTeX() {
  if [[ $miktexFlag == true ]]; then

    # Register GPG key for Ubuntu and Linux Mint.
    sudo apt-key adv \
         --keyserver hkp://keyserver.ubuntu.com:80 \
         --recv-keys $miktexGpgKey

    # Installation source: Ubuntu 18.04, Linux Mint 19.
    echo "deb http://miktex.org/download/${miktexSource}" \
      | sudo tee /etc/apt/sources.list.d/miktex.list

    # Update database
    sudo apt-get update

    # MiKTeX
    sudo apt-get -y install \
                    miktex \
                    latexmk

    # Finish MikTeX shared installation setup.
    sudo miktexsetup --shared=yes finish
    sudo initexmf --admin --set-config-value [MPM]AutoInstall=1

    # The MiXTeX team told me to update the package database twice.  See:
    # https://github.com/MiKTeX/miktex/issues/724
    sudo mpm --admin --update
    mpm --update
    sudo mpm --admin --update
    mpm --update

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ TexLive

installTexLive() {
  if [[ $texliveFlag == true ]]; then

    # TexLive compnents
    sudo apt-get -y install \
                    texlive \
                    texlive-latex-extra \
                    texlive-publishers \
                    texlive-science \
                    texlive-pstricks \
                    texlive-pictures \
                    texlive-metapost \
                    texlive-music \
                    latexmk

    # Create ls-R databases
    sudo mktexlsr

    # Init suer tree.
    tlmgr init-usertree

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Stop WSL Autogeneration

stopWslAutogeneration () {
  if [[ $wslFlag == true ]]; then
    say 'Stop WSL autogeneration'
    cd "$cwd" || exit

    # Copy host and resolv.conf to /etc.
    sudo cp -v hosts /etc/.

    # TODO: Not supported yet.
    # sudo cp -v resolv.conf /etc/.

    # Create wsl.conf from template.
    template=wsl-template.conf
    conf=/etc/wsl.conf
    sudo cp -v $template $conf

    # Replace wsl-template.conf/WSL-[HOST|USER]-Name with
    #         bootstrap-archlinux/config/$wsl[Host|User]Name
    sudo sed -i "s/WSL-HOST-NAME/$wslHostName/g" $conf
    sudo sed -i "s/WSL-USER-NAME/$wslUserName/g" $conf
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Make and configure ssh directory.

installSshDir() {
  if [[ $sshDirFlag == true ]]; then
    say 'Initialize .ssh/config.'
    mkdir -p "$cloneRoot/ssh"

    # Create ssh/config from template.
    template=ssh-config-template
    config=$cloneRoot/ssh/config
    cp -v "$template" "$config"

    # Repace ssh-config-template/GIT-USER-NAME with
    #        bootstrap-archlinux/config/$gitUserName
    sed -i "s/GIT-USER-NAME/$gitUserName/g" "$config"

    # Repace ssh-config-template/WSL-HOST-NAME with
    #        bootstrap-archlinux/config/$wslHostName
    sed -i "s/WSL-HOST-NAME/$wslHostName/g" "$config"

    say 'Initialize .ssh/config.vim'
    touch "$cloneRoot/ssh/config.vim"
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Generate sshkey for this host

generateSshHostKey () {
  if [[ $sshHostKeyFlag == true ]]; then
    say 'Generate ssh host key.'
    mkdir -p "$cloneRoot/ssh"
    ssh-keygen -f "$cloneRoot/ssh/$wslHostName"
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Set sshkey permissions

setSshPermissions() {

  if [[ $sshHostKeyFlag == true ]]; then
    say 'Setting ssh permissions.'
    chmod 600 "$cloneRoot/ssh/$wslHostName"
    chmod 644 "$cloneRoot/ssh/$wslHostName.pub"
  fi
  # chmod 700 $cloneRoot/ssh/.git
}

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/resolve.conf

installResolvConf() {
  if [[ $resolvFlag == true ]]; then
    [[ -f resolv.conf ]] \
      && sudo cp -fv resolv.conf /etc/resolv.conf \
      && echo "/etc/resolv.conf replaced." \
      || (echo "resolv.conf not found." && exit)
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/wsl.conf

installWslConf() {
  [[ $wslFlag == true ]] \
    && [[ -f wsl.conf ]] \
    && sudo cp -fv wsl.conf /etc/wsl.conf \
    && echo "/etc/wsl.conf replaced."
}

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/hosts

installHosts() {
  [[ $hostsFlag == true ]] \
    && [[ -f hosts ]] \
    && sudo cp -fv hosts /etc/hosts \
    && echo "/etc/hosts replaced."
}

# -------------------------------------------------------------------------- }}}
# {{{ Install rbenv

installRbEnv() {
  if [[ $rbenvFlag == true ]]; then

    # Install rbenv dependencies.
    sudo apt-get -y install \
                    autoconf \
                    bison \
                    build-essential \
                    curl \
                    git \
                    libgdbm-dev \
                    libncurses5-dev \
                    libffi-dev \
                    libreadline-dev \
                    libreadline-dev \
                    libssl-dev \
                    libyaml-dev \
                    ruby-bundler \
                    zlib1g-dev

    git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv

    echo "RbEnv installed."

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install Ruby Build

installRubyBuild() {
  if [[ $rbenvFlag == true ]]; then

    git clone https://github.com/rbenv/ruby-build.git \
        $HOME/.rbenv/plugins/ruby-build

    echo "ruby-build installed."

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Update .bashrc

updateBashRc() {
  if [[ $rbenvFlag == true ]]; then

    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
    echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
    echo ".bashrc updated."

    # Update path, rbenv, and shell
    export PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
    source $HOME/.bashrc
    echo "Path and rbenv loaded with new shell."

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ loadNeovimluginsconf

loadNeovimPlugins() {
  if [[ $neovimPluginsFlag == true ]]; then
    say 'Loading neovim plugins.'
    nvim
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ loadTmuxPlugins

loadTmuxPlugins() {
  if [[ $tmuxPluginsFlag == true ]]; then
    say 'Loading TMUX plugins.'
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ loadVimPlugins

loadVimPlugins() {
  if [[ $vimPluginsFlag == true ]]; then
    say 'Loading vim plugins.'
    vim
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Kick start this script.

main "$@"

# -------------------------------------------------------------------------- }}}
