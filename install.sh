#!/bin/bash
# {{{ Usefull URLs

# Useful documentation.
#   https://miktex.org/howto/install-miktex-unx
#   https://linuxize.com/post/how-to-install-ruby-on-debian-9/

# -------------------------------------------------------------------------- }}}
# {{{ Main function 

main() {
  loadConfig
  # updateOS
  # installDefaultPackages
  # configureGit
  # initProfile
  # installMikTeX
  # installTexLive
  installWslConfig
  # installHosts
  # installXWindows
  # installRbEnv
  # installRubyBuild
  # updateBashRc
  # installRuby
  # installRubyGems
  # personalizeOS
}

# -------------------------------------------------------------------------- }}}
# {{{ Source configuraiton options.

loadConfig() {
  [[ -f config ]] \
    && sudo cat config \
    && source config \
    || (echo "config not found." && exit)
}

# -------------------------------------------------------------------------- }}}
# {{{ Update OS

updateOS() {
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get -y autoremove
}

# -------------------------------------------------------------------------- }}}
# {{{ Install my default packages.

installDefaultPackages() {
  sudo apt-get install -y \
              curl \
              dirmngr \
              fzf \
              gcc \
              git \
              make \
              neovim \
              npm \
              ranger
}

# -------------------------------------------------------------------------- }}}
# {{{ Configure git email and user.

configureGit() {
  git config --global user.email "$gitEmail"
  git config --global user.name "$gitName"
  git config --global credential.helper cache 
  git config --global credential.helper 'cache --timeout=32000'
  git config --global core.editor vim 
}

# -------------------------------------------------------------------------- }}}
# {{{ Initialize .profile

initProfile() {
  if [[ $profileFlag == 1 ]]; then
    cp -v .profile $HOME/.
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ MiKTeX

installMikTeX() {
  if [[ $miktexFlag == 1 ]]; then

    # Register GPG key for Ubuntu and Linux Mint.
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $miktexGpgKey

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

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ TexLive

installTexLive() {
  if [[ $texliveFlag == 1 ]]; then

    # TexLive compnents 
    sudo apt-get -y install
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

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/wsl.config

installWslConfig() {
  [[ $wslFlag == 1 ]] && echo "wslFlag: 1"
  [[ -f wsl.conf ]]  && echo "wsl.conf found"
  
  
  [[ $wslFlag == 1 ]] \
    && [[ -f wsl.conf ]] \
    && sudo cp -fv wsl.conf /etc/wsl.conf \
    && echo "/etc/wsl.conf replaced." \
    || echo "Error:  /etc/wsl.conf did not update."
}

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/hosts

installHosts() {
  [[ hostsFlag == 1 ]] \
    && [[ -f hosts ]] \
    && sudo mv -fv hosts /etc/hosts \
    && echo "/etc/hosts replaced."
}

# -------------------------------------------------------------------------- }}}
# {{{ xWindows Suppport
#
# Note: Use PowerShell with Administrator rights.  I use VcXsrv to support
# X-windows clients when needed.  I use choco to install packages on Windows.
# The powershell command is listed for reference only.
# choco install -y vcxsr
#
# X Windos support.

installXWindows() {
  [[ $xWindowsFlag == 1 ]] \
    && sudo sudo apt-get install -y vim-gtk xsel \
    && echo "X Windows support installed."
}

# -------------------------------------------------------------------------- }}}
# {{{ Install rbenv

installRbEnv() {
  if [[ $rbenvFlag == 1 ]]; then

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
  if [[ $rbenvFlag == 1 ]]; then

    git clone https://github.com/rbenv/ruby-build.git \
        $HOME/.rbenv/plugins/ruby-build

    echo "ruby-build installed."

  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Update .bashrc

updateBashRc() {
  if [[ $rbenvFlag == 1 ]]; then

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
# {{{ Install Ruby

installRuby() {
  if [[ $rbenvFlag == 1 ]]; then

    rbenv init
    rbenv install $rubyVersion
    rbenv global $rubyVersion

    echo "Ruby installed."
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Install Ruby Gems

installRubyGems() {
  if [[ $rbenvFlag == 1 ]]; then

    # Install Ruby Gems 
    gem install \
        bundler \
        rake \
        rspec

    echo "Ruby Gems installed."
  fi
}

# -------------------------------------------------------------------------- }}}
# {{{ Personalize debian 

personalizeOS() {
  if [[ $emendFlag == 1 ]]; then

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
