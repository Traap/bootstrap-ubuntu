#!/bin/bash
# {{{ Usefull URLs

# Useful documentation.
#   https://miktex.org/howto/install-miktex-unx
#   https://linuxize.com/post/how-to-install-ruby-on-debian-9/

# -------------------------------------------------------------------------- }}}
# {{{ Main function

main() {
  loadConfig
  updateOS
  installDefaultPackages
  configureGit

  installHosts
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
  personalizeOS
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
# {{{ xWindows Supppor
#
# Note: Use PowerShell with Administrator rights.  I use VcXsrv to support
# X-windows clients when needed.  I use choco to install packages on Windoz.
# The powershell command is listed for reference only.
# choco install -y vcxsrv
#
# X Windoz support.

installXWindows() {
  [[ $xWindowsFlag == true ]] \
    && sudo sudo apt-get install -y vim-gtk xsel \
    && echo "X Windows support installed."
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
# {{{ InstgallBashGitPrompt

installBashGitPrompt() {
  if [[ $gitBashPromptFlag == true ]]; then
    say 'Instgall bash-git-prompt.'
    rm -rf ~/.bash-git-prompt
    src=https://github.com/magicmonty/bash-git-prompt
    dst=~/.bash-git-prompt
    git clone "$src" "$dst"
  fi
}

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
# {{{ Personalize debian

personalizeOS() {
  if [[ $emendFlag == true ]]; then

    echo "Personalization of debian.";

    echo "Install and build emend from a subshell."
    (
      echo "PATH and rbenv must be known."
      export PATH=$HOME/.rbenv/bin:$PATH
      eval "$(rbenv init -)"

      echo "Clone emend";
      mkdir -p $cloneRoot;
      cd $cloneRoot;
      git clone http://github.com/Traap/emend.git;

      echo "Build and install emend";
      cd emend;
      rake build:emend;
    )

    echo "Emend this computer from a subshell."
    (
      echo "PATH and rbenv must be known."
      export PATH=$HOME/.rbenv/bin:$PATH
      eval "$(rbenv init -)"

      echo "Clone emend-computer";
      cd $cloneRoot;
      git clone http://github.com/Traap/emend-computer.git;

      echo "Emend this computer";
      cd emend-computer;
      emend --verbose --nodryrun --bundle debian;
    )

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Kick start this script.

main "$@"

# -------------------------------------------------------------------------- }}}
