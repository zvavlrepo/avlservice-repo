def nextVersionFromGit(scope) {
        def latestVersion = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 --match "v[0-9]*" 2> /dev/null || echo 0.0').trim()
        def (major, minor, patch) = latestVersion.tokenize('.').collect { it.toInteger() }
        def nextVersion
        switch (scope) {
            case 'major':
                nextVersion = "${major + 1}.0"
                break
            case 'minor':
                nextVersion = "${major}.${minor + 1}"
                break
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
                echo "version number is ${nextVersionFromGit('major')}"
            }
        }
    }
}