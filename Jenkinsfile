pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                echo 'Check for the working status'
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t bashry/dockerapp:latest .'
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                    docker stop dockerapp-container || true
                    docker rm dockerapp-container || true
                    docker run -d --name dockerapp-container -p 3000:3000 --env-file /home/ubuntu/bashry/.env bashry/dockerapp:latest
                '''
            }
        }
    }
    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed! Check the Jenkins console output.'
        }
    }
}