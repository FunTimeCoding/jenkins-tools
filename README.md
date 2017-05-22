# JenkinsTools

## Setup

This section explains how to configure this project.

Example config. The default location is ~/.jenkins-tools.conf.

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

This section explains how to use this project.

Upload a job.

```sh
bin/put-job.sh job.xml
```

Specify a config file for any command.

```sh
bin/list-jobs.sh --config ~/.jenkins-tools-mine.conf
```


## Development

This section explains how to use scripts that are intended to ease the development of this project.

Install development tools.

```sh
sudo apt-get install shellcheck
```

Run style check and show all concerns.

```sh
./run-style-check.sh
```

Build the project like Jenkins.

```sh
./build.sh
```
