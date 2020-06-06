# GitHub Application Manager
A linux tool similar to `apt` and `yum` that is used to search for and install applications from GitHub. Works on many different application types that are stored in repos as releases, including:
- deb
- rpm
- AppImage
- Electron (tar/gz)

`gam` will automatically add a command to your `PATH` and if GNOME is installed it will add a shortcut to the application as well. These are automatically removed when uninstalling applications.

***Proud to have made the top spot on [r/github](https://www.reddit.com/r/github) and [r/coolgithubprojects](https://www.reddit.com/r/coolgithubprojects) on launch day.***

![demo](demo/gam.gif)

## Contents
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [User mode](#user-mode)
- [Automatic update checking](#automatic-update-checking)

## Installation
First, install the prequisites.

Debian/Ubuntu:
``` bash
apt install -y ncurses-bin debianutils jq curl tar xz-utils
```

CentOS:
``` bash
yum install -y ncurses which jq curl tar
```

Then install `gam`:
``` bash
sudo curl https://raw.githubusercontent.com/Fmstrat/gam/master/gam -o /usr/local/bin/gam
sudo chmod 755 /usr/local/bin/gam
```

## Configuration
The first time you use `gam`, you will need to run:
``` bash
sudo gam create-config
```
This will create an `/etc/gam.conf` file with the following settings that can be configured to your liking.
``` bash
# The folder to install applications into
INSTALL_FOLDER=/opt/github

# Where to symlink executables for the path
BIN_FOLDER=/bin

# Where to place temporary cache files
TMP_FOLDER=/tmp/gam

# If you hit GitHub API limits, you can use a Personal Access Token
# Create one here: https://github.com/settings/tokens/new
#GITHUB_CREDS=username:token
```

### GitHub API limits
If you use `gam` a lot at once, you may hit GitHub API limits. If you find installs or searches are not working, create a Personal Access Token (PAT) here: https://github.com/settings/tokens/new

This can be included in the `/etc/gam.conf` file to increase API limits to 5000 hits per day.

## Usage
Usage can be shown by typing `gam` on the command line.
``` bash
$ gam
Usage:
  gam list                     # List installed applications
  gam search <search string>   # Get a list of repos that match a search string
  gam install <author/repo>    # Install one or more applications
  gam check [<author/repo>]    # Check currently installed applications for updates
  gam upgrade [<author/repo>]  # Upgrade one, more, or all currently installed applications
  gam remove <author/repo>     # Remove one or more applications
  gam create-config            # Create initial configuration
  gam update                   # Update your version of gam
  
Optional paramaters:
  -i|--include <string> [--include <string 2>]
  # If more than one asset is matched during an install, use the --include flag to match
  # the asset with the include string. Every include string must match to be considered
  # for install.

  -e|--exclude <string> [--exclude <string 2>]
  # If more than one asset is matched during an install, use the --exclude flag to not
  # match any assets with the excluded string. Every exclude string must not match to be
  # considered for install.

  -u:--user
  # Run in rootless user mode with a ~/.config/gam/gam.conf configuration, executables in,
  # ~/bin (by default), and no support for rpm or deb files.

  -d|--debug
  # Debug mode to show what is happening behind the scenes.
```

## User mode
You may run this application without `sudo` or root by utilizing the `--user` flag. The biggest changes will be that application shortcuts will be placed into `~/bin` by default instead of your path, and `dep` and `rpm` packages are not supported. The basic process is:
``` bash
gam create-config --user
gam list --user
gam install author/app --user
```

## Automatic update checking
The `gam check` command will return an exit code of `133` if an application needs updating. This can be used to auto-check for updates. A combination of `cron` and your `bashrc` can be used to check for updates.

To check for changes daily at the system level:
``` bash
echo '/usr/local/bin/gam check >/dev/null 2>&1; echo $? > /tmp/gam-status' |sudo tee /etc/cron.daily/gam
sudo chmod +x /etc/cron.daily/gam
```

Then, to have your shell alert you about updates:
``` bash
echo 'if [ -f /tmp/gam-status ] && (( $(cat /tmp/gam-status) == 133 )); then echo "[:] There are new gam updates"; fi' >> ~/.bashrc
```