# Jenkins Tools


## Operation

Specify a config file.

```sh
./bin/script.sh -c /Users/shiin/.jenkins-tools-mine.conf
```

Additional arguments still work.

```sh
./bin/get-job.sh -c ~/.jenkins-tools-infra.conf mw-unit-and-integration-trunk > job.xml
```

Upload config.

```sh
./bin/put-job.sh -c ~/.jenkins-tools-staging.conf job.xml
```


## Configuration

Example config. Default path is ~/.jenkins-tools.conf.

```sh
# required
USER="areitzel"
PASSWORD="insecure"
NAME="Alexander Reitzel"
MAIL="funtimecoding@gmail.com"
# `JENKINS_URL` is optional and falls back to `http://localhost:8080`.
JENKINS_URL="http://ci.dev"
PROJECTS_DIR="/home/shiin/code"
# LDAP configuration.
SERVER="1.2.3.4"
ROOT_DN="foo=bar"
USER_SEARCH_BASE="foo=bar"
USER_SEARCH="foo=bar"
GROUP_SEARCH_BASE="foo=bar"
MANAGER_DN="foo=bar"
MANAGER_PASSWORD="insecure"
```


## Development

Run any script verbosely if you want to debug it.

```sh
./bin/script.sh -v
```

Install development tools.

```sh
brew install shellcheck
```

Run code style check.

```sh
./run-style-check.sh
```
