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
# JENKINS_URL is optional and falls back to `http://localhost:8080`
JENKINS_URL="http://ci.dev"
PROJECTS_DIR="/home/shiin/code"
```


## Development

Run any script verbosely if you want to debug it.

```sh
./bin/script.sh -v
```

Install static analysis tool.

```sh
brew install shellcheck
```
