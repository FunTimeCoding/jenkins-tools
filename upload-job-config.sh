#!/bin/sh -e

~/src/jenkins-tools/bin/delete-job.sh jenkins-tools || true
~/src/jenkins-tools/bin/put-job.sh jenkins-tools job.xml
