# JenkinsTools

## Setup

Install project dependencies.

```sh
script/setup.sh
```

Example config. The default location is ~/.jenkins-tools.sh.

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


## Usage

This section explains how to use the project.

Run the main program.

```sh
bin/jt
```

Upload a job.

```sh
bin/put-job.sh job.xml
```


## Development

This section explains how to improve the project.

Configure Git on Windows before cloning. This avoids problems with Vagrant and VirtualBox.

```sh
git config --global core.autocrlf input
```

Create the development virtual machine on Linux and Darwin.

```sh
script/vagrant/create.sh
```

Create the development virtual machine on Windows.

```bat
script\vagrant\create.bat
```

Run tests.

```sh
script/test.sh [--help]
```

Run style check.

```sh
script/check.sh [--help]
```

Build project.

```sh
script/build.sh
```
