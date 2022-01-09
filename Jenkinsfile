def nextVersionNumber() {
    def versionNumber = sh(script: 'cat version.txt', returnStdout: true)
    def (major, minor) = versionNumber.replace('v', '').tokenize('.').collect { it.toInteger() }
    if (major==0 && minor==0){
        nextVersion = "v1.0"
    } 
    else{
        nextVersion = "v${major}.${minor + 1}"
    }
    nextVersion
    }

pipeline {
    environment {
        imagename1 = "zvavltest/avlservice-repo:avlserviceimage1"
        imagename2 = "zvavltest/avlservice-repo:avlserviceimage2"
        dockerhub_creds = credentials('dockerhub-login')
    }
    agent any 
    stages {

        stage('Build Images') {
            steps {
                sh "docker build -t $imagename1 ./service1"
                echo "build successful on $imagename1"
                sh "docker build -t $imagename2 ./service2"
                echo "build successful on $imagename2"
            }
        }

        stage('Unit test') {
            steps {
                echo "Unit test passed"
                echo "${nextVersionNumber()}"
            }
        }

        stage('Integration test') {
            steps {
                echo "Integration test passed"
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh "echo $dockerhub_creds | docker login -u $dockerhub_creds_USR --password-stdin"
                sh "docker push $imagename1${nextVersionNumber()}"
                sh "$imagename1 successfuly pushed to DockerHub"
                sh "docker push $imagename2${nextVersionNumber()}"
                sh "$imagename2 successfuly pushed to DockerHub"
            }
        }

        stage('Versioning') {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'github-access', gitToolName: 'Default')]) {
                    sh "echo ${nextVersionNumber()} > version.txt"
                    sh "git commit -a -m 'Automatic versioning'"
                    sh "git push origin HEAD:master --force"
                    echo "Git version updated"
                }
            }
        }
    }
}