# Jenkins Tools

## Configuration

This section explains how to configure this project.

Example config. The default location is `~/.jenkins-tools.conf`.

```sh
# Required
SSH_KEY=~/.ssh/id_rsa
NAME="Alexander Reitzel"
MAIL=funtimecoding@gmail.com

# Optional
USERNAME=areitzel
PASSWORD=changeme
# Default: http://localhost:8080
JENKINS_LOCATOR=http://example.org
PROJECTS_DIRECTORY=/home/shiin/Code
PLUGINS="git
log-parser
greenballs"

# LDAP
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
