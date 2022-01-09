def nextVersionNumber() {
    def versionNumber = sh(script: 'cat version.txt', returnStdout: true)
    def (major, minor) = versionNumber.replace('v', '').tokenize('.').collect { it.toInteger() }
    if (versionNumber == "v0.0") {
        nextVersion = "v1.0"
    }else{
        nextVersion = "v${major}.${minor + 1}"
    }
    nextVersion
    }

pipeline {
    environment {
        imagename1 = "avlserviceimage1"
        imagename2 = "avlserviceimage2"
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
            }
        }

        stage('Integration test') {
            steps {
                echo "Integration test passed"
                echo "next version number ${nextVersionNumber()}"
            }
        }

        /*stage('Versioning') {
            steps {
                
            }
        }*/
    }
}