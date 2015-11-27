# Jenkins Tools

## Operation

Specify a config file for any command.

```sh
./bin/script.sh -c ~/.jenkins-tools-mine.conf
./bin/get-job.sh -c ~/.jenkins-tools-infra.conf mw-unit-and-integration-trunk > job.xml
```

Upload a job.

```sh
./bin/put-job.sh -c ~/.jenkins-tools-staging.conf job.xml
```


## Configuration

Example config. Default location is ~/.jenkins-tools.conf.

```sh
# Required
USERNAME="areitzel"
PASSWORD="insecurePassword"
NAME="Alexander Reitzel"
MAIL="funtimecoding@gmail.com"

# Optional
# Default for JENKINS_LOCATOR is http://localhost:8080.
JENKINS_LOCATOR="http://ci.dev"
PROJECTS_DIR="/home/shiin/Code"

# LDAP
SERVER="127.0.0.1"
ROOT_DN="foo=bar"
USER_SEARCH_BASE="foo=bar"
USER_SEARCH="foo=bar"
GROUP_SEARCH_BASE="foo=bar"
MANAGER_DN="foo=bar"
MANAGER_PASSWORD="insecurePassword"
```


## Development

Run any script with some verbose output.

```sh
./bin/script.sh -v
```

Run any script in debug mode. This sets `-x`.

```sh
./bin/script.sh -d
```

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
