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

flag | purpose
---- | ----
bashrcFlag   | RBENV information is written to .bashrca when true.
cloneRoot    | Root to clone emend and emend-computer into. 
emendFlag    | Install and build gem emend when true.
gitEmail     | Your git email address ... Not mine :)
gitName      | Your git name ... Not mine :)
hostsFlag    | Caution this will force replace /etc/hosts
miktexFlag   | Install MiKTeX when true.
miktexGpgKey | Debian or Ubuntu key needed to access MiKTeX download.
miktexSource | Source options needed to download MiKTeX.
profileFlag  | Create default .profile to source .bashrc 
rbenvFlag    | RBENV is installed when true.
rubyVersion  | Ruby version to install with RBENV.
ubuntuFlag   | Special handling for Ubutun & Ruby when true.
wslFlag      | Caution this will force replace /etc/wsl.config.
xWindowsFlag | Install X windows components when true.

## Step 1
All coponents that can be installed without needing to restart a shell.
``` bash
./bootstrap-step-01
```

## Step 2
All components that require the shell to be restarted.
``` bash
./bootstrap-step-02
```
