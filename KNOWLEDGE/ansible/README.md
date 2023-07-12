# Ansible deploy for SicpaTrace

This project is to deploy SicpaTrace using Ansible. It uses two repos, "ansible" for code
and "ansible_environments" for environment variables and scripts.
##### Usage:

Clone both Code and Environments repos (Using tt077 as example project) :
```sh
$ git clone ssh://git@psdgit.sicpa-net.ads:7999/cdo/ansible.git
$ git clone ssh://git@psdgit.sicpa-net.ads:7999/tt77/ansible_environments.git
```
You should have two directories now: `ansible` and `ansible_environments`

Before any deploy we have to load some environment variables to be used by Ansible. *(Edit scripts/prepare_default_environment_variables.sh according with your needs)*:
```sh
$ cd ansible_environments
$ export DEPLOY=CORE or DEPLOY=GOLDMASTER or DEPLOY=BLUEMOON(not ready yet)
$ scripts/prepare_default_environment_variables.sh
$ source default_environment_variables.sh
```
To deploy a specific server:
```sh
$ cd ansible
$ scripts/deploy_server.sh [env_name] [server_name]
```
To deploy all servers:
```sh
$ cd ansible
$ scripts/deploy_all.sh [env_name]
```
