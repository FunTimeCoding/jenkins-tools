#!/bin/sh -e

~/Code/Personal/jenkins-tools/bin/delete-job.sh jenkins-tools || true
~/Code/Personal/jenkins-tools/bin/put-job.sh jenkins-tools job.xml
