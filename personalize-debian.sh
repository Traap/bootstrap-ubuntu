#!/bin/bash
# {{{ Clone and build emend, when needed.

if [[ $emendFlag == 1 ]]; then

  eval "$(rbenv init -)"

  source $HOME/.bashrc 

  mkdir -p $cloneRoot
  cd $cloneRoot
  git clone http://github.com/Traap/emend.git
  cd emend

  # Build and install emend
  rake build:emend

  # Clone and emend this system.
  cd ..
  git clone http://github.com/Traap/emend-computer.git

  # Personalize Traap's environment.
  # Note:  Only linux commands are ran when run from a wsl distro.
  cd emend-computer
  emend --verbose --nodryrun --bundle debian

fi

# -------------------------------------------------------------------------- }}}
