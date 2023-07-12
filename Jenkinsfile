#!/usr/bin/env groovy

pipeline {
    agent { label 'master' }

    environment {
        BUILD_RELEASE_VERSION = readMavenPom().getVersion().replace("-SNAPSHOT", "")
        GIT_TAG_COMMIT = sh(script: 'git describe --tags --always', returnStdout: true).trim()
        PVERSION = getpVersion(env.GIT_BRANCH, env.BUILD_RELEASE_VERSION)
    }

    stages {

        stage('Versions information') {
            steps {
                ansiColor('xterm') {
                    echo "TERM=${env.TERM}"
                }
                echo 'Compiling Branch... ' + env.GIT_BRANCH
                echo 'BUILD_RELEASE_VERSION... ' + env.BUILD_RELEASE_VERSION
                echo "is GIT_TAG_COMMIT ${GIT_TAG_COMMIT}"
                echo "pversion -> " + getpVersion(env.GIT_BRANCH, env.BUILD_RELEASE_VERSION)
            }
        }

        stage('Build') {
            steps {
                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                    withCredentials([string(credentialsId: 'artifactoryPass', variable: 'ARTIFACTORY_PASSWORD')]) {
                        echo 'Pulling... ' + env.GIT_BRANCH
                        sh '''
                        mvn versions:set -DnewVersion=${PVERSION}
                        mvn -q clean deploy 
                        '''
                    }
                }
            }
        }

    }
}


/*
wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                      sh """
                        export ANSIBLE_FORCE_COLOR=true
                        ansible-playbook -i "${ENV}"/hosts -e deploy_env="${ENV}" deploy.yml --limit ${SERVER}
                      """
*/

@NonCPS

def getpVersion(String branchName, String version) {


    def previous_result = branchName.replace("core/","");
    def branchParts = previous_result.split("/")

    String prefix = branchParts[0]
    String branchWithoutPrefix = branchParts.size() > 1 ? branchParts[1] : prefix

    def result = previous_result.replace("/","-");

    print "The prefix for the branch is ${prefix}"
    print "The branchWithoutPrefix for the branch is ${branchWithoutPrefix}"
    print "The version for the branch is ${version}"

    switch (prefix) {
        case ["master"]:
            result = "${version}"
            break
        case ["release"]:
            result = "${branchWithoutPrefix}"
            break
        case ["develop"]:
            result = "${version}-develop-SNAPSHOT"
            break
        default:  // Other cases - Prefix is ignored and generate artifactory [Version-Branch(Without Prefix)-SNAPSHOT]
            result = "${version}-${branchWithoutPrefix}-SNAPSHOT"
            break
    }

    return result
}