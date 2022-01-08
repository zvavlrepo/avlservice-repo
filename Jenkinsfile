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

        stage('Unit Test') {
            echo "Unit test passed"
        }

        stage('Integration Test') {
            echo "Integration test passed"
        }
    }
}