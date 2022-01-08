pipeline {
    enviroment {
        imagename1 = "avlserviceimage1"
        imagename2 = "avlserviceimage2"
    }
    agent any 
    stages {
        stage('Build Images Stage') {
            steps {
                sh "docker build -t $imagename1 ./service1"
                echo "build successful on $imagename1"
            }
        }
    }
}