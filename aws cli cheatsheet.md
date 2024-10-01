# AWS CLI Cheatsheet

http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
https://www.youtube.com/watch?v=_wiGpBQGCjU





## Setup

### Overview
- Virtualbox
- Ubuntu 14.04 LTS VM, 64-bit
http://releases.ubuntu.com/14.04/ubuntu-14.04.4-desktop-amd64.iso
- create new machine, settings
  - System / Processor
    - Enable PAE/NX
  - System / Acceleration
    - Paravirtualization Interface: Default
    - Enable VT-x/AMD-V
    - Enable Nested Paging
  - Display / Screen
    - Video Memory: 128MB
    - Acceleration: Enable 3D Acceleration
- boot
- install

### install Virtualbox Guest Additions, passwordless sudo
```shell
echo $USER
sudo echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo su
apt-get update
apt-get install -y build-essential dkms linux-headers-$(uname -r)
cd /media/aws-admin/
sh ./VBoxLinuxAdditions.run
shutdown now
```

### install AWS CLI
```shell
sudo apt-get install -y python-dev python-pip
sudo pip install awscli
aws --version
aws configure
```

### Bash one-liners
```shell
cat <file> # output a file
tee # split output into a file
cut -f 2 # print the 2nd column, per line
sed -n '5{p;q}' # print the 5th line in a file
sed 1d # print all lines, except the first
tail -n +2 # print all lines, starting on the 2nd
head -n 5 # print the first 5 lines
tail -n 5 # print the last 5 lines

expand # convert tabs to 4 spaces
unexpand -a # convert 4 spaces to tabs
wc # word count
tr ' ' \\t # translate / convert characters to other characters

sort # sort data
uniq # show only unique entries
paste # combine rows of text, by line
join # combine rows of text, by initial column value
```
<br/><br/><br/>





## Cloudtrail - Logging and Auditing

http://docs.aws.amazon.com/cli/latest/reference/cloudtrail/
5 Trails total, with support for resource level permissions

```shell
# list all trails
aws cloudtrail describe-trails

# list all S3 buckets
aws s3 ls

# create a new trail
aws cloudtrail create-subscription \
    --name awslog \
    --s3-new-bucket awslog2016

# list the names of all trails
aws cloudtrail describe-trails --output text | cut -f 8

# get the status of a trail
aws cloudtrail get-trail-status \
    --name awslog

# delete a trail
aws cloudtrail delete-trail \
    --name awslog

# delete the S3 bucket of a trail
aws s3 rb s3://awslog2016 --force

# add tags to a trail, up to 10 tags
aws cloudtrail add-tags \
    --resource-id awslog \
    --tags-list "Key=log-type,Value=all"

# list the tags of a trail
aws cloudtrail list-tags \
    --resource-id-list 

# remove a tag from a trail
aws cloudtrail remove-tags \
    --resource-id awslog \
    --tags-list "Key=log-type,Value=all"
```
<br/><br/><br/>





## IAM

### Users

https://blogs.aws.amazon.com/security/post/Tx15CIT22V4J8RP/How-to-rotate-access-keys-for-IAM-users
http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-limits.html
Limits = 5000 users, 100 group, 250 roles, 2 access keys / user

http://docs.aws.amazon.com/cli/latest/reference/iam/index.html

```shell
# list all user's info
aws iam list-users

# list all user's usernames
aws iam list-users --output text | cut -f 6

# list current user's info
aws iam get-user

# list current user's access keys
aws iam list-access-keys

# crate new user
aws iam create-user \
    --user-name aws-admin2

# create multiple new users, from a file
allUsers=$(cat ./user-names.txt)
for userName in $allUsers; do
    aws iam create-user \
        --user-name $userName
done

# list all users
aws iam list-users --no-paginate

# get a specific user's info
aws iam get-user \
    --user-name aws-admin2

# delete one user
aws iam delete-user \
    --user-name aws-admin2

# delete all users
# allUsers=$(aws iam list-users --output text | cut -f 6);
allUsers=$(cat ./user-names.txt)
for userName in $allUsers; do
    aws iam delete-user \
        --user-name $userName
done
```



### Password policy

http://docs.aws.amazon.com/cli/latest/reference/iam/

```shell
# list policy
# http://docs.aws.amazon.com/cli/latest/reference/iam/get-account-password-policy.html
aws iam get-account-password-policy

# set policy
# http://docs.aws.amazon.com/cli/latest/reference/iam/update-account-password-policy.html
aws iam update-account-password-policy \
	--minimum-password-length 12 \
	--require-symbols \
	--require-numbers \
	--require-uppercase-characters \
	--require-lowercase-characters \
	--allow-users-to-change-password

# delete policy
# http://docs.aws.amazon.com/cli/latest/reference/iam/delete-account-password-policy.html
aws iam delete-account-password-policy
```



### Access Keys

http://docs.aws.amazon.com/cli/latest/reference/iam/

```shell
# list all access keys
aws iam list-access-keys

# list access keys of a specific user
aws iam list-access-keys \
    --user-name aws-admin2

# create a new access key
aws iam create-access-key \
    --user-name aws-admin2 \
    --output text | tee aws-admin2.txt

# list last access time of an access key
aws iam get-access-key-last-used \
    --access-key-id AKIAINA6AJZY4EXAMPLE

# deactivate an acccss key
aws iam update-access-key \
    --access-key-id AKIAI44QH8DHBEXAMPLE \
    --status Inactive \
    --user-name aws-admin2

# delete an access key
aws iam delete-access-key \
    --access-key-id AKIAI44QH8DHBEXAMPLE \
    --user-name aws-admin2
```



### Groups, Policies, Managed Policies

http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
http://docs.aws.amazon.com/cli/latest/reference/iam/

```shell
# list all groups
aws iam list-groups

# create a group
aws iam create-group --group-name FullAdmins

# delete a group
aws iam delete-group \
    --group-name FullAdmins

# list all policies
aws iam list-policies

# get a specific policy
aws iam get-policy \
    --policy-arn <value>

# list all users, groups, and roles, for a given policy
aws iam list-entities-for-policy \
    --policy-arn <value>

# list policies, for a given group
aws iam list-attached-group-policies \
    --group-name FullAdmins

# add a policy to a group
aws iam attach-group-policy \
    --group-name FullAdmins \
    --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# add a user to a group
aws iam add-user-to-group \
    --group-name FullAdmins \
    --user-name aws-admin2

# list users, for a given group
aws iam get-group \
    --group-name FullAdmins

# list groups, for a given user
aws iam list-groups-for-user \
    --user-name aws-admin2

# remove a user from a group
aws iam remove-user-from-group \
    --group-name FullAdmins \
    --user-name aws-admin2

# remove a policy from a group
aws iam detach-group-policy \
    --group-name FullAdmins \
    --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# delete a group
aws iam delete-group \
    --group-name FullAdmins
```
<br/><br/><br/>




## S3

https://docs.aws.amazon.com/cli/latest/reference/s3api/index.html#cli-aws-s3api

```shell
# list existing S3 buckets
aws s3 ls

# create a bucket name, using the current date timestamp
bucket_name=test_$(date "+%Y-%m-%d_%H-%M-%S")
echo $bucket_name

# create a public facing bucket
aws s3api create-bucket --acl "public-read-write" --bucket $bucket_name

# verify bucket was created
aws s3 ls | grep $bucket_name

# check for public facing s3 buckets (should show the bucket name you created)

aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | xargs -I {} bash -c 'if [[ $(aws s3api get-bucket-acl --bucket {} --query '"'"'Grants[?Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers` && Permission==`READ`]'"'"' --output text) ]]; then echo {} ; fi'

# check for public facing s3 buckets, updated them to be private

aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | xargs -I {} bash -c 'if [[ $(aws s3api get-bucket-acl --bucket {} --query '"'"'Grants[?Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers` && Permission==`READ`]'"'"' --output text) ]]; then aws s3api put-bucket-acl --acl "private" --bucket {} ; fi'

# check for public facing s3 buckets (should be empty)

aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | xargs -I {} bash -c 'if [[ $(aws s3api get-bucket-acl --bucket {} --query '"'"'Grants[?Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers` && Permission==`READ`]'"'"' --output text) ]]; then echo {} ; fi'
```





## EC2

### keypairs

http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html

```shell
# list all keypairs
# http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-key-pairs.html
aws ec2 describe-key-pairs

# create a keypair
# http://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html
aws ec2 create-key-pair \
    --key-name <value> --output text

# create a new local private / public keypair, using RSA 4096-bit
ssh-keygen -t rsa -b 4096

# import an existing keypair
# http://docs.aws.amazon.com/cli/latest/reference/ec2/import-key-pair.html
aws ec2 import-key-pair \
    --key-name keyname_test \
    --public-key-material file:///home/apollo/id_rsa.pub

# delete a keypair
# http://docs.aws.amazon.com/cli/latest/reference/ec2/delete-key-pair.html
aws ec2 delete-key-pair \
    --key-name <value>
```




### Security Groups

http://docs.aws.amazon.com/cli/latest/reference/ec2/index.html

```shell
# list all security groups
aws ec2 describe-security-groups

# create a security group
aws ec2 create-security-group \
    --vpc-id vpc-1a2b3c4d \
    --group-name web-access \
    --description "web access"

# list details about a securty group
aws ec2 describe-security-groups \
    --group-id sg-0000000

# open port 80, for everyone
aws ec2 authorize-security-group-ingress \
    --group-id sg-0000000 \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/24

# get my public ip
my_ip=$(dig +short myip.opendns.com @resolver1.opendns.com);
echo $my_ip

# open port 22, just for my ip
aws ec2 authorize-security-group-ingress \
    --group-id sg-0000000 \
    --protocol tcp \
    --port 80 \
    --cidr $my_ip/24

# remove a firewall rule from a group
aws ec2 revoke-security-group-ingress \
    --group-id sg-0000000 \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/24

# delete a security group
aws ec2 delete-security-group \
    --group-id sg-00000000
```




## Images

https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html

```shell
# list all private AMI's, ImageId and Name tags
aws ec2 describe-images --filter "Name=is-public,Values=false" \
    --query 'Images[].[ImageId, Name]' \
    --output text | sort -k2

# delete an AMI, by ImageId
aws ec2 deregister-image --image-id ami-00000000

```


## Instances

http://docs.aws.amazon.com/cli/latest/reference/ec2/index.html

```shell
# list all instances (running, and not running)
# http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html
aws ec2 describe-instances

# list all instances running
aws ec2 describe-instances --filters Name=instance-state-name,Values=running

# create a new instance
# http://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
aws ec2 run-instances \
    --image-id ami-f0e7d19a \	
    --instance-type t2.micro \
    --security-group-ids sg-00000000 \
    --dry-run

# stop an instance
# http://docs.aws.amazon.com/cli/latest/reference/ec2/terminate-instances.html
aws ec2 terminate-instances \
    --instance-ids <instance_id>

# list status of all instances
# http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instance-status.html
aws ec2 describe-instance-status

# list status of a specific instance
aws ec2 describe-instance-status \
    --instance-ids <instance_id>
    
# list all running instance, Name tag and Public IP Address
aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[].[PublicIpAddress, Tags[?Key==`Name`].Value | [0] ]' \
  --output text | sort -k2
```



### Tags
```shell
# list the tags of an instance
# http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-tags.html
aws ec2 describe-tags

# add a tag to an instance
# http://docs.aws.amazon.com/cli/latest/reference/ec2/create-tags.html
aws ec2 create-tags \
    --resources "ami-1a2b3c4d" \
    --tags Key=name,Value=debian

# delete a tag on an instance
# http://docs.aws.amazon.com/cli/latest/reference/ec2/delete-tags.html
aws ec2 delete-tags \
    --resources "ami-1a2b3c4d" \
    --tags Key=Name,Value=
```
<br/><br/><br/>





## Cloudwatch


### Log Groups
http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/WhatIsCloudWatchLogs.html
http://docs.aws.amazon.com/cli/latest/reference/logs/index.html#cli-aws-logs

##### create a group
http://docs.aws.amazon.com/cli/latest/reference/logs/create-log-group.html
```shell
aws logs create-log-group \
	--log-group-name "DefaultGroup"
```

##### list all log groups
http://docs.aws.amazon.com/cli/latest/reference/logs/describe-log-groups.html
```shell
aws logs describe-log-groups

aws logs describe-log-groups \
	--log-group-name-prefix "Default"
```

##### delete a group
http://docs.aws.amazon.com/cli/latest/reference/logs/delete-log-group.html
```shell
aws logs delete-log-group \
	--log-group-name "DefaultGroup"
```



### Log Streams
```shell

# Log group names can be between 1 and 512 characters long. Allowed
# characters include a-z, A-Z, 0-9, '_' (underscore), '-' (hyphen),
# '/' (forward slash), and '.' (period).

# create a log stream
# http://docs.aws.amazon.com/cli/latest/reference/logs/create-log-stream.html
aws logs create-log-stream \
	--log-group-name "DefaultGroup" \
	--log-stream-name "syslog"

# list details on a log stream
# http://docs.aws.amazon.com/cli/latest/reference/logs/describe-log-streams.html
aws logs describe-log-streams \
	--log-group-name "syslog"

aws logs describe-log-streams \
	--log-stream-name-prefix "syslog"

# delete a log stream
# http://docs.aws.amazon.com/cli/latest/reference/logs/delete-log-stream.html
aws logs delete-log-stream \
	--log-group-name "DefaultGroup" \
	--log-stream-name "Default Stream"
```



## Cloudwatch - Monitoring
http://docs.aws.amazon.com/cli/latest/reference/cloudwatch/index.html


# ADITIONAL CHEETSHEAT
### ----------------------------------------------------------------

## What is the AWS CLI?

AWS CLI stands for Amazon Web Services Command Line Interface. When managing your AWS services there are a few options as far as tools go. Two of the most common options are using the AWS Console, or AWS CLI. The AWS Console is a web interface that you log into to manage your AWS services. In contrast to the AWS Console is AWS CLI. It is a great tool to manage AWS resources across different accounts, regions, and environments from the command line. It allows you to control services manually or create automation with scripts.

If you haven't installed AWS CLI yet start at the Installing the AWS CLI Guide from Amazon.

### Pro-tip 1 - use the command-completion feature.

We think the best cheatsheet you can have for AWS CLI is the command-completion feature. It allows you to use the Tab key to complete a partially entered command. It will either complete your command or display a list of suggested commands. It isn't always automatically installed, so you'll need to configure it manually. Here is the AWS guide to get it up and running.

### Pro-tip 2 - use the help command.

When you need a little extra help just lean on the AWS CLI help command to get detailed documentation on what is available. To use this command you just append help at the end of a command name. For example, if you do 'aws help' it will show the general AWS CLI options and list all the services. If you need to see what all the available commands for AWS EC2 specifically, you would type 'aws ec2 help.' It will become a huge aid to you in becoming an AWS CLI pro.

### Pro-tip 3 - use jq.

This cheatsheet utilizes jq, a lightweight and flexible command-line JSON processor. We highly recommend using it for AWS CLI. You can find more information on it at the Github repository for it.
Config

### Create profiles
```shell
 aws configure --profile profilename
````


Output format

aws configure output format {json, yaml, yaml-stream, text, table}



Specify your AWS Region

aws configure region (region-name)



API Gateway

List API Gateway IDs and Names

aws apigateway get-rest-apis | jq -r ‘.items[ ] | .id+” “+.name’



List API Gateway keys

aws apigateway get-api-keys | jq -r ‘.items[ ] | .id+” “+.name’



List API Gateway domain names

aws apigateway get-domain-names | jq -r ‘.items[ ] | .domainName+” “+.regionalDomainName’



List resources for API Gateway

aws apigateway get-resources --rest-api-id ee86b4cde | jq -r ‘.items[ ] | .id+” “+.path’



Find Lambda for API Gateway resource

aws apigateway get-integration --rest-api-id (id) --resource-id (resource id) --http-method GET | jq -r ‘.uri’



Amplify

List Amplify apps and source repository

aws amplify list-apps | jq -r ‘.apps[ ] | .name+” “+.defaultDomain+”



CloudFront

List CloudFront distributions and origins

aws cloudfront list-distributions | jq -r ‘.DistributionList.Items[ ] | .DomainName+” “+.Origins.Items[0].DomainName’



Create a new invalidation

aws cloudfront create-invalidation [distribution-id]



CloudWatch

List information about an alarm

aws cloudwatch describe-alarms | jq -r ‘.MetricAlarms[ ] | .AlarmName+” “+.Namespace+” “+.StateValue’



Delete an alarm or alarms (you can delete up to 100 at a time)

aws cloudwatch delete-alarms --alarm-names (alarmnames)



Cognito

List user pool IDs and names

aws cognito-idp list-user-pools --max-results 60 | jq -r ‘.UserPools[ ] | .Id+” “+.Name’



List phone and email of all users

aws cognito-idp list-users --user-pool-id (resource) | jq -r ‘.Users[ ].Attributes | from_entries | .sub + “ “ + .phone_number + “ “ + .email’



DynamoDB

List DynamoDB tables

aws dynamodb list-tables | jq -r .TableNames [ ]



Get all items from a table

aws dynamodb scan --table-name events



Get item count from a table

aws dynamodb scan --table-name events --select count | jq .ScannedCount



Get item using key

aws dynamodb get-item --table-name events --key ‘{“email””"email@example.com”}}’



Get specific fields from an item

aws dynamodb get-item --table-name events --key ‘{“email””"email@example.com"}}’ --attributes-to-get event_type



Delete item using key

aws dynamodb delete-item --table-name events --key ‘{“email””email@domain.com”}}’



EBS

Complete a Snapshot

aws ebs complete-snapshot (snapshot-id)



Start a Snapshot

aws ebs start-snapshot --volume-size (value)



Get a Snapshot block

aws ebs get-snapshot-block

--snapshot-id (value)

--block-index (value)

--block-token (value)



EC2

List Instance ID, Type and Name

aws ec2 describe-instances | jq -r '.Reservations[].Instances[]|.InstanceId+" "+.InstanceType+" "+(.Tags[] | select(.Key == "Name").Value)'



List Instances with public IP address and Name

aws ec2 describe-instances --query 'Reservations[*].Instances[?not_null(PublicIpAddress)]' | jq -r '.[][]|.PublicIpAddress+" "+(.Tags[]|select(.Key=="Name").Value)'



List VPCs and CIDR IP Block

aws ec2 describe-vpcs | jq -r '.Vpcs[]|.VpcId+" "+(.Tags[]|select(.Key=="Name").Value)+" "+.CidrBlock'



List Subnets for a VPC

aws ec2 describe-subnets --filter Name=vpc-id,Values=vpc-0d1c1cf4e980ac593 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)'



List Security Groups

aws ec2 describe-security-groups | jq -r '.SecurityGroups[]|.GroupId+" "+.GroupName'



Print Security Groups for an Instance

aws ec2 describe-instances --instance-ids i-0dae5d4daa47fe4a2 | jq -r '.Reservations[].Instances[].SecurityGroups[]|.GroupId+" "+.GroupName'



Edit Security Groups of an Instance

aws ec2 modify-instance-attribute --instance-id i-0dae5d4daa47fe4a2 --groups sg-02a63c67684d8deed sg-0dae5d4daa47fe4a2



Print Security Group Rules as FromAddress and ToPort

aws ec2 describe-security-groups --group-ids sg-02a63c67684d8deed | jq -r '.SecurityGroups[].IpPermissions[]|. as $parent|(.IpRanges[].CidrIp+" "+($parent.ToPort|tostring))'



Add Rule to Security Group

aws ec2 authorize-security-group-ingress --group-id sg-02a63c67684d8deed --protocol tcp --port 443 --cidr 35.0.0.1



Delete Rule from Security Group

aws ec2 revoke-security-group-ingress --group-id sg-02a63c67684d8deed --protocol tcp --port 443 --cidr 35.0.0.1



Edit Rules of Security Group

aws ec2 update-security-group-rule-descriptions-ingress --group-id sg-02a63c67684d8deed --ip-permissions 'ToPort=443,IpProtocol=tcp,IpRanges=[{CidrIp=202.171.186.133/32,Description=Home}]'



Delete Security Group

aws ec2 delete-security-group --group-id sg-02a63c67684d8deed



ECS

Create an ECS cluster

aws ecs create-cluster --cluster-name=NAME --generate-cli-skeleton



Create an ECS service

aws ecs create-service



EKS

Create a cluster

aws eks create-cluster --name (cluster name)



Delete a cluster

aws eks delete-cluster --name (cluster name)



List descriptive information about a cluster

aws eks describe-cluster --name (cluster name)



List clusters in your default region

aws eks list-clusters



Tag a resource

aws eks tag-resource --resource-arn (resource_ARN) --tags (tags)



Untag a resource

aws eks untag-resource --resource-arn (resource_ARN) --tag-keys (tag-key)



ElastiCache

Get information about a specific cache cluster

aws elasticache describe-cache-clusters | jq -r ‘.CacheClusters[ ] | .CacheNodeType+” “+.CacheClusterId’



List ElastiCache replication groups

aws elasticache describe-replication-groups | jq -r ‘.ReplicationGroups [ ] | .ReplicationGroupId+” “+.NodeGroups[ ].PrimaryEndpoint.Address’



List ElastiCache snapshots

aws elasticache describe-snapshots | jq -r ‘.Snapshots[ ] | .SnapshotName’



Create ElastiCache snapshot

aws elasticache create-snapshot --snapshot-name backend-login-hk-snap-1 --replication-group-id backend-login-hk --cache-cluster-id backend-login-hk



Delete ElastiCache snapshot

aws elasticache delete-snapshot --snapshot-name login-snap-1



Scale up/down ElastiCache replica

aws elasticache increase-replica-count --replication-group-id backend-login --apply-immediately

aws elasticache decrease-replica-count --replication-group-id backend-login --apply-immediately



ELB

List ELB Hostnames

aws elbv2 describe-load-balancers --query ‘LoadBalancers[*].DNSName’ | jq -r ‘to_entries[ ] | .value’



List ELB ARNs

aws elbv2 describe-load-balancers | jq -r ‘.LoadBalancers[ ] | .LoadBalancerArn’



List of ELB target group ARNs

aws elbv2 describe-target-groups | jq -r ‘.TargetGroups[ ] | .TargetGroupArn’



Find instances for a target group

aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:ap-northwest-1:20394823094:targetgroup/wordpress-ph/203942b32a23 | jq -r ‘.TargetHealthDescriptions[ ] | .Target.Id’



IAM Group

List groups

aws iam list-groups | jq -r .Groups[ ].GroupName



Add/Delete groups

aws iam create-group --group-name (groupName)



List policies and ARNs

aws iam list-policies | jq -r ‘.Policies[ ]|.PolicyName+” “+.Arn’

aws iam list-policies --scope AWS | jq -r ‘.Policies[ ]|.PolicyName+” “+.Arn’

aws iam list-policies --scope Local | jq -r ‘.Policies[ ]|.PolicyName+” “+.Arn’



List user/group/roles for a policy

aws iam list-entities-for-policy --policy-arn arn:aws:iam:2308345:policy/example-ReadOnly



List policies for a group

aws iam list-attached-group-policies --group-name (groupname)



Add policy to a group

aws iam attach-group-policy --group-name (groupname) --policy-arn arn:aws:iam::aws:policy/exampleReadOnlyAccess



Add user to a group

aws iam add-user-to-group --group-name (groupname) --user-name (username)



Remove user from a group

aws iam remove-user-from-group --group-name (groupname) --user-name (username)



List users in a group

aws iam get-group --group-name (groupname)



List groups for a user

aws iam list-groups-for-user --user-name (username)



Attach/detach policy to a group

aws iam attach-group-policy --group-name (groupname) --policy-arn arn:aws:iam::aws:policy/DynamoDBFullAccess

aws iam detach-group-policy --group-name (groupname) --policy-arn arn:aws:iam::aws:policy/DynamoDBFullAccess



IAM User

List userId and UserName

aws iam list-users | jq -r ‘.Users[ ]|.UserId+” “+.UserName’



Get single user

aws iam get-user --user-name (username)



Add user

aws iam create-user --user-name (username)



Delete user

aws iam delete-user --user-name (username)



List access keys for user

aws iam list-access-keys --user-name (username) | jq -r .AccessKeyMetadata[ ].AccessKeyId



Delete access key for user

aws iam delete-access-key --user-name (username) --access-key-id (accessKeyID)



Activate/deactivate access key for user

aws iam update-access-key --status Active --user-name (username) --access-key-id (access key)

aws iam update-access-key --status Inactive --user-name (username) --access-key-id (access key)



Generate new access key for user

aws iam create-access-key --user-name (username) | jq -r ‘.AccessKey | .AccessKeyId+” “+.SecretAccessKey’



Lambda

List Lambda functions, runtime, and memory

aws lambda list-functions | jq -r ‘.Functions[ ] | .FunctionName+” “+.Runtime+” “+(.MemorySize|tostring)’



List Lambda layers

aws lambda list-layers | jq -r ‘.Layers[ ] | .LayerName’



List source event for Lambda

aws lambda list-event-source-mappings | jq -r ‘.EventSourceMappings[ ] | .FunctionArn+” “+.EventSourceArn’



Download Lambda code

aws lambda get-function --function-name DynamoToSQS | jq -r .Code.Location



RDS

List DB clusters

aws rds describe-db-clusters | jq -r ‘.DBClusters[ ] | .DBClusterIdentifier+” “+.Endpoint’



List DB instances

aws rds describe-db-instances | jq -r ‘.DBInstances[ ] | .DBInstanceIdentifier+” “+.DBInstanceClass+” “+.Endpoint.Address’



Take DB Instance Snapshot

aws rds create-db-snapshot --db-snapshot-identifier snapshot-1 --db-instance-identifier dev-1

aws rds describe-db-snapshots --db-snapshot-identifier snapshot-1 --db-instance-identifier general



Take DB cluster snapshot

aws rds create-db-cluster-snapshot --db-cluster-snapshot-identifier



Route53

Create hosted zone

aws route53 create-hosted-zone --name exampledomain.com



Delete hosted zone

aws route53 delete-hosted-zone --id example



Get hosted zone

aws route53 get-hosted-zone --id example



List hosted zones

aws route53 list-hosted-zones



Create a record set

To do this you’ll first need to create a JSON file with a list of change items in the body and use the CREATE action. For example the JSON file would look like this.

{
"Comment": "CREATE/DELETE/UPSERT a record",
"Changes": [{
"Action": "CREATE",
"ResourceRecordSet":{
"Name": "a.example.com",
"Type": "A",
"TTL": 300,
"ResourceRecords":[{"Value":"4.4.4.4"}]
}}]
}

Once you have a JSON file with the correct information like above you will be able to enter the command

aws route53 change-resource-record-sets --hosted-zone-id (zone-id) --change-batch file://exampleabove.json



Update a record set

To do this you’ll first need to create a JSON file with a list of change items in the body and use the UPSERT action. This will either create a new record set with the specified value, or updates a record set if it already exists. For example the JSON file would look like this.

{
"Comment": "CREATE/DELETE/UPSERT a record",
"Changes": [{
"Action": "UPSERT",
"ResourceRecordSet":{
"Name": "a.example.com",
"Type": "A",
"TTL": 300,
"ResourceRecords": [{"Value":"4.4.4.4"}]
}}]
}

Once you have a JSON file with the correct information like above you will be able to enter the command

aws route53 change-resource-record-sets --hosted-zone-id (zone-id) --change-batch file://exampleabove.json



Delete a record set

To do this you’ll first need to create a JSON file with a list of the record set values you want to delete in the body and use the DELETE action. For example the JSON file would look like this.

{
"Comment": "CREATE/DELETE/UPSERT a record",
"Changes": [{
"Action": "DELETE",
"ResourceRecordSet": {
"Name": "a.example.com",
"Type": "A",
"TTL": 300,
"ResourceRecords": [{"Value":"4.4.4.4"}]
}}]
}

Once you have a JSON file with the correct information like above you will be able to enter the following command.

aws route53 change-resource-record-sets --hosted-zone-id (zone-id) --change-batch file://exampleabove.json



S3

List Buckets

aws s3 ls



List files in a Bucket

aws s3 ls s3://mybucket



Create Bucket


aws s3 mb s3://bucket-name
make_bucket: bucket-name



Delete Bucket

aws s3 rb s3://bucket-name --force



Download S3 object to local

aws s3 cp s3://bucket-name
download: ./backup.tar from s3://bucket-name/backup.tar



Upload local file as S3 object

aws s3 cp backup.tar s3://bucket-name
upload: ./backup.tar to s3://bucket-name/backup.tar



Delete S3 object

aws s3 rm s3://bucket-name/secret-file.gz .
delete: s3://bucket-name/secret-file.gz



Download bucket to local

aws s3 sync s3://bucket-name/ /media/pasport-ultra/backup



Upload local directory to bucket


aws s3 sync (directory) s3://bucket-name/



Share S3 object without public access


aws s3 presign s3://bucket-name/file-name --expires-in (time value)
https://bucket-name.s3.amazonaws.com/file-name.pdf?AWSAccessKeyId=(key)&Expires=(value)&Signature=(value)



SNS

List SNS topics


aws sns list-topics | jq -r ‘.Topics[ ] | .TopicArn’



List SNS topic and related subscriptions


aws sns list-subscriptions | jq -r ‘.Subscriptions[ ] | .TopicArn+” “+.Protocol+” “+.Endpoint’



Publish to SNS topic


aws sns publish --topic-arn arn:aws:sns:ap-southeast-1:232398:backend-api-monitoring



SQS

List queues

aws sqs list-queues | jq -r ‘.QueueUrls[ ]’



Create queue

aws sqs create-queue --queue-name public-events.fifo | jq -r .queueURL



Send message

aws sqs send-message --queue-url (url) --message-body (message)



Receive message

aws sqs receive-message --queue-url (url) | jq -r ‘.Messages[ ] | .Body’



Delete message

aws sqs delete-message --queue url (url) --receipt-handle (receipt handle)



Purge queue

aws sqs purge-queue --queue-url (url)



Delete queue

aws sqs delete-queue --queue-url (url)

