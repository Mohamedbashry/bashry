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
                    docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker stop devops-web || true
                    docker rm devops-web || true
                    docker run -d \
                        --name devops-web \
                        --restart unless-stopped \
                        -p 80:3000 \
                        ${DOCKER_IMAGE}:${BUILD_NUMBER}
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