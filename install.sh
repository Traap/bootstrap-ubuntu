#!/bin/bash
# {{{ Usefull URLs
#
# Useful documentation.
#   https://miktex.org/howto/install-miktex-unx
#   https://linuxize.com/post/how-to-install-ruby-on-debian-9/

# -------------------------------------------------------------------------- }}}
# {{{ Source configuraiton options.

[[ -f config ]] \
  && sudo cat config \
  && source config \
  || (echo "config not found." && exit)

# -------------------------------------------------------------------------- }}}
# {{{ Update OS

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

# -------------------------------------------------------------------------- }}}
# {{{ Install my default packages.

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

# -------------------------------------------------------------------------- }}}
# {{{ Configure git email and user.

git config --global user.email "$gitEmail"
git config --global user.name "$gitName"
git config --global credential.helper cache 
git config --global credential.helper 'cache --timeout=32000'
git config --global core.editor vim 

# -------------------------------------------------------------------------- }}}
# {{{ Initialize .profile

if [[ $profileFlag == 1 ]]; then

  cp -v .profile $HOME/.

fi

# -------------------------------------------------------------------------- }}}
# {{{ MiKTeX

if [[ $miktexFlag == 1 ]]; then

  # Register GPG key for Ubuntu and Linux Mint.
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $miktexGpgKey

  # Installation source: Ubuntu 18.04, Linux Mint 19.
  echo "deb http://miktex.org/download/${miktexSource}" \
    | sudo tee /etc/apt/sources.list.d/miktex.list

  # MiKTeX
  sudo apt-get -y update
  sudo apt-get -y install miktex

  # Finish MikTeX shared installation setup.
  sudo miktexsetup --shared=yes finish
  sudo initexmf --admin --set-config-value [MPM]AutoInstall=1

  # LaTeX make
  sudo apt-get -y install latexmk

fi

# -------------------------------------------------------------------------- }}}
# {{{ TexLive

if [[ $texliveFlag == 1 ]]; then

  # MiKTeX
  sudo apt-get -y update
  sudo apt-get -y install
                  texlive \
                  texlive-latex-extra \
                  texlive-publishers \
                  texlive-science \
                  texlive-pstricks \
                  texlive-pictures \
                  texlive-metapost \
                  texlive-music

  # Create ls-R databases
  sudo mktexlsr

  # LaTeX make
  sudo apt-get -y install latexmk

fi

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/wsl.config

[[ wslFlag == 1 ]] \
  && [[ -f wsl.config ]] \
  && sudo mv -fv wsl.config /etc/wsl.conf \
  && echo "/etc/wsl.config replaced."

# -------------------------------------------------------------------------- }}}
# {{{ Force replace /etc/hosts

[[ hostsFlag == 1 ]] \
  && [[ -f hosts ]] \
  && sudo mv -fv hosts /etc/hosts \
  && echo "/etc/hosts replaced."

# -------------------------------------------------------------------------- }}}
# {{{ Install rbenv

if [[ $rbenvFlag == 1 ]]; then

  # Install rbenv dependencies.
  sudo apt-get -y update
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

  git clone https://github.com/rbenv/rbenv.git \
      $HOME/.rbenv

  echo "RbEnv installed."

  git clone https://github.com/rbenv/ruby-build.git \
      $HOME/.rbenv/plugins/ruby-build

  echo "ruby-build installed."

  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc

  echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc

  echo ".bashrc updated."

  # Activate rbenv
  export PATH=$HOME/.rbenv/bin:$PATH

  eval "$(rbenv init -)"

  source $HOME/.bashrc

  rbenv init
  rbenv install $rubyVersion
  rbenv global $rubyVersion

  # Install Ruby Gems 
  gem install \
      bundler \
      rake \
      rspec

fi

# -------------------------------------------------------------------------- }}}
# {{{ xWindows Suppport
#
# Note: Use PowerShell with Administrator rights.  I use VcXsrv to support
# X-windows clients when needed.  I use choco to install packages on Windows.
# The powershell command is listed for reference only.
# choco install -y vcxsr
#
# X Windos support.

[[ $xWindowsFlag == 1 ]] \
  && sudo sudo apt-get install -y vim-gtk xsel \
  && echo "X Windows support installed."

# -------------------------------------------------------------------------- }}}
# {{{ Clone and build emend, when needed.

if [[ $emendFlag == 1 ]]; then
  mkdir -p $cloneRoot
  cd $cloneRoot
  git clone http://github.com/Traap/emend.git
  cd emend
  rake build:emend

  # Rspec doc
  rspec --format documentation

  # Clone and emend this system.
  cd ..
  git clone http://github.com/Traap/emend-computer.git
  cd emend-computer

  # Personalize Traap's environment.
  # Note:  Only linux commands are ran when run from a wsl distro.
  emend --verbose --nodryrun --bundle debian

fi

# -------------------------------------------------------------------------- }}}
