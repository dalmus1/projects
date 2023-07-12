#!/bin/bash
set -o pipefail
ENV="$1"
SERVER="$2"
ARGS="$3"

if [ -d ../ansible_environments ]; then
  cd ../ansible_environments
else
  echo ../ansible_environments not found.
  exit 1
fi

LOGDIR="logs"
if [ ! -d "$LOGDIR" ]; then mkdir $LOGDIR; fi

echo Deploying $SERVER in $ENV environment...
ansible-playbook -i $ENV -e deploy_env=$ENV ${SERVER}.yml $ARGS | tee $LOGDIR/${SERVER}.log
deploy=$?

if [ $deploy -gt 0 ]; then
  echo ERROR: Error deploying $SERVER. See its logs. | tee -a $LOGDIR/deploy.log
  exit 1
else
  echo OK: $SERVER has been successfully deployed. | tee -a $LOGDIR/deploy.log
fi
