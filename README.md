# JenkinsTools

## Setup

Install project dependencies:

```sh
script/setup.sh
```

Example configuration:

```sh
USERNAME=example
PASSWORD=example
KEY=/home/example/.ssh/id_rsa
EMAIL=example@example.org
HOST_NAME=ci.example.org
PORT=2222
PLUGINS="git
log-parser
greenballs"

# Optional directory service
SERVER=127.0.0.1
ROOT_DN=foo=bar
USER_SEARCH_BASE=foo=bar
USER_SEARCH=foo=bar
GROUP_SEARCH_BASE=foo=bar
MANAGER_DN=foo=bar
MANAGER_PASSWORD=changeme
```

The default location is ~/.jenkins-tools.sh.


## Usage

Run the main program:

```sh
bin/jt
```

Run the main program inside the container:

```sh
docker run -it --rm funtimecoding/jenkins-tools
```


## Development

Configure Git on Windows before cloning:

```sh
git config --global core.autocrlf input
```

Install NFS plug-in for Vagrant on Windows:

```bat
vagrant plugin install vagrant-winnfsd
```

Create the development virtual machine on Linux and Darwin:

```sh
script/vagrant/create.sh
```

Create the development virtual machine on Windows:

```bat
script\vagrant\create.bat
```

Run tests, style check and metrics:

```sh
script/test.sh [--help]
script/check.sh [--help]
script/measure.sh [--help]
```

Build project:

```sh
script/build.sh
```

Install Debian package:

```sh
sudo dpkg --install build/jenkins-tools_0.1.0-1_all.deb
```

Show files the package installed:

```sh
dpkg-query --listfiles jenkins-tools
```
