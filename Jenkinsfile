def versionNumber() {
    def lastSuccessfulBuildNumber = 0
    def build = currentBuild.previousBuild
    while (build != null) {
        if (build.result == "SUCCESS")
        {
            lastSuccessfulBuildNumber = build.number as Integer
            break
        }
            build = build.previousBuild
    }
    def major = 1
    def minor = lastSuccessfulBuildNumber
    def nextVersion = "v${major}.${minor}"
    nextVersion
    }

pipeline {
    environment {
        imagename1 = "avlserviceimage1"
        imagename2 = "avlserviceimage2"
    }
    agent any 
    stages 

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
                echo "version number ${versionNumber()}"
            }
        }
    }
}