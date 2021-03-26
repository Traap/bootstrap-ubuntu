# debian-bootstrap
Bootstrap Debian or Ubuntu into WSL (Windows Sybsystem for Linux).


## Prerequisits:
1. You must have administrative rights to your computer.
2.  [Microsoft Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) Installation Guide for Windows 10 is your starting point.
3. Start the Debian or Ubuntu machine and follow the on screen prompts.

## Prepare to bootstrap Debian or Ubuntu
```bash
git clone https://github.com/Traap/debian-bootstrap
cd debian-bootstrap
```

## Review configuraiton
``` bash
cat config
```

# Configuration options
Flags are set to 1 or 0, true or false, respectively.

flag             | purpose
----             | ----
bashrcFlag       | RBENV information is written to .bashrca when true.
cloneRoot        | Root to clone emend and emend-computer into.
echoConfigFlag   | Echo config to sysout.
emendFlag        | Install and build gem emend when true.
gitconfigFlag    | Set your git email, user and credential helpers.
gitEmail         | Your git email address ... Not mine :)
gitName          | Your git name ... Not mine :)
graphVizFlag     | Install Graphviz application.
javaJreFlag      | Install Java open jdk.
miktexGpgKey     | Debian or Ubuntu key needed to access MiKTeX download.
miktexSource     | Source options needed to download MiKTeX.
muttFlag         | Install neomutt and mutt-wizard.
osUpdateFlag     | Update operating system.
profileFlag      | Create default .profile to source .bashrc
rbenvFlag        | RBENV is installed when true.
rubyVersion      | Ruby version to install with RBENV.
rustFlag         | Install rust.
rustProgramsFlag | Install rust application programs.
texliveFlag      | Install TexLive full.
tldrFlag         | Why not?
ubuntuFlag       | Special handling for Ubutun & Ruby when true.
wslFlag          | Caution this will force replace /etc/wsl.config.
xWindowsFlag     | Install X windows components when true.

## Step
All coponents that can be installed without needing to restart a shell.
``` bash
./install.sh
```

