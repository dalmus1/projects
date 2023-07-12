#!/bin/bash
ENV="$1"

LOGDIR="../ansible_environments/logs"
if [ ! -d "$LOGDIR" ]; then mkdir $LOGDIR; fi

rm -rf $LOGDIR/* >/dev/null 2>&1
echo -e \\n\\n --- Deploy summary --- \\n > $LOGDIR/deploy.log

# Add Ansible extra verbosity
if [ "$VERBOSE" = true ]; then
  ARGS="-vv"
fi

# Add DMSDB to deploy if not explicity
if [ -z "$DEPLOY_DMSDB" ]; then
  DEPLOY_DMSDB=true
fi

if [ -z "$DEPLOY_SSAVP" ]; then
  DEPLOY_SSAVP=false
fi

if [ -z "$DEPLOY_MASTERS" ]; then
  DEPLOY_MASTERS=true
fi

if [ -z "$DEPLOY_B2B" ]; then
  DEPLOY_B2B=false
fi

if [ -z "$DEPLOY_SERVERS" ]; then
  DEPLOY_SERVERS="mdm dms webapp asproxy"
fi

if [ "$DEPLOY_SSAVP" = true ]; then
  DEPLOY_SERVERS="$DEPLOY_SERVERS ssavp"
fi

if [ "$DEPLOY_MASTERS" = true ]; then
  DEPLOY_SERVERS="$DEPLOY_SERVERS masters"
fi

if [ "$DEPLOY_B2B" = true ]; then
  DEPLOY_SERVERS="$DEPLOY_SERVERS b2b"
fi

if [ "$DEPLOY_DMSDB" = true ]; then
#  ansible-playbook -i $ENV -e deploy_env=$ENV dmsdb.yml
  bash scripts/deploy_server.sh $ENV dmsdb $ARGS
  deploy_result=$?

  if [ ${deploy_result} -gt 0 ]; then
   echo ERROR: Deploying error occured in DMSDB. Aborting all other servers deployment process.
   exit 1
  fi
else
  echo Skipping DMSDB deploy as requested.
fi

#echo Deploying All other servers
#echo mdm.yml webapp.yml dms.yml asproxy.yml masters.yml| tr ' ' '\n' |
#xargs -I{} -P 5 bash -c "ansible-playbook -i $ENV -e deploy_env=$ENV {}" -- %
#deploy_result=$?

echo Deploying all requested servers: $DEPLOY_SERVERS
for SERVER in $DEPLOY_SERVERS; do
 echo "$SERVER"
done |
xargs -I{} -P 10 bash -c '
{
 #echo "Deploying "{} in $0 environment
 bash scripts/deploy_server.sh $0 {} $@
}' $ENV $ARGS

deploy_result=$?

cat ../ansible_environments/logs/deploy.log

if [ ${deploy_result} -gt 0 ]; then
 echo ERROR: Deploy finished with errors. Look for \"ERROR:\" and \"fatal:\" in log
 exit 1
fi