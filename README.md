# GitHub Application Manager
A linux tool to search and install applications from GitHub. Works on many different application types that are stored in repos as releases, including:
- deb
- rpm
- AppImage
- Electron (tar/gz)

![demo](demo/gam.gif)

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

# Where to place temporary cache files
TMP_FOLDER=/tmp/gam

# If you hit GitHub API limits, you can use a Personal Access Token
# Create one here: https://github.com/settings/tokens/new
#GITHUB_CREDS=username:token
```
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
  gam upgrade [<author/repo>]  # Upgrade one, more, or all currently installed applications
  gam remove <author/repo>     # Remove one or more applications
  gam create-config            # Create initial configuration
  
Optional paramaters:
  -i|--include <string> [--include <string 2>]
  # If more than one asset is matched during an install, use the --include flag to match
  # the asset with the include string. Every include string must match to be considered
  # for install.

  -e|--exclude <string> [--exclude <string 2>]
  # If more than one asset is matched during an install, use the --exclue flag to not
  # match any assets with the excluded string. Every exclude string must not match to be
  # considered for install.

  -d|--debug
  # Debug mode to show what is happening behind the scenes.
```