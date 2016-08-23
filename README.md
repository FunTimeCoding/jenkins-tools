# Jenkins Tools

## Operation

Specify a config file for any command.

```sh
bin/script.sh --config ~/.jenkins-tools-mine.conf
bin/get-job.sh --config ~/.jenkins-tools-infra.conf mw-unit-and-integration-trunk > job.xml
```

Upload a job.

```sh
bin/put-job.sh --config ~/.jenkins-tools-staging.conf job.xml
```


## Configuration

Example config. The default location is `~/.jenkins-tools.conf`.

```sh
# Required
SSH_KEY=~/.ssh/id_rsa
NAME="Alexander Reitzel"
MAIL=funtimecoding@gmail.com

# Optional
# Default for JENKINS_LOCATOR is http://localhost:8080.
USERNAME=areitzel
PASSWORD=changeme
JENKINS_LOCATOR=http://ci.dev
PROJECTS_DIRECTORY=/home/shiin/Code
PLUGINS="git
log-parser
greenballs"

# LDAP
SERVER=127.0.0.1
ROOT_DN="foo=bar"
USER_SEARCH_BASE="foo=bar"
USER_SEARCH="foo=bar"
GROUP_SEARCH_BASE="foo=bar"
MANAGER_DN="foo=bar"
MANAGER_PASSWORD=changeme
```


## Development

Install development tools on OS X.

```sh
brew install shellcheck
```

Install development tools on Debian.

```sh
sudo apt-get install shellcheck
```

Run code style check.

```sh
./run-style-check.sh
```
