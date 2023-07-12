Role Name
=========

This role is intented for sicpa blockchain application deployments

Requirements
------------

It requieres to be run together with wildfly for artifact deployment

Role Variables
--------------

The following variables need to be set in order for this role to work:

- blockchain_artifactory_base_url:

The path in artifactory where the artifact is stored. I.e:
blockchain_artifactory_base_url: gssd-dev-snapshots-local/com/sicpa

- blockchain_artifact:

The artifact name with no version number. I.e:
blockchain_artifact: sicpabcproxy

- blockchain_version:

The version number. I.e:
blockchain_version: 0.0.1-SNAPSHOT

- blockchain_artifact_extension:

This is the artifact extension to be treated. It could be war, jar or rpm. I.e:
blockchain_artifact_extension: war

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

You could develop your playbook to run this role like this for instance:

- name: Deploy Blockchain server
  hosts: sicpabc
  become: yes

  vars_files:
   - "{{ deploy_env }}/group_vars/blockchain.yml"

  roles:
    - firewalld
    - jre
    - blockchain

License
-------

SICPA

Author Information
------------------

Author: Carlos Alvarez Asenjo
Date: 6th of august, 2019
