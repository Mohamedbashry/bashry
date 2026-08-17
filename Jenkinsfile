pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'bashry/dockerapp'
    }

    stages {
        stage('Test') {
            steps {
                echo 'Check for the working status '
            }
        }
        stage('Cleanup') {
            steps {
                sh 'docker image prune -f'
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t bashry/dockerapp:${BUILD_NUMBER} -t bashry/dockerapp:latest .'
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker logout
                    '''
                }
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
            echo '✅ Pipeline completed successfully!!!'
        }
        failure {
            echo '❌ Pipeline failed! Check the Jenkins console output.'
        }
    }
}