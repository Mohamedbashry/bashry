pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                echo 'Check for the working status'
            }
        }
        stage('developing'){
            steps{
                echo "checked from deploying and completed"
                echo"check completed"
            }
        }
        stage('deploy'){
            steps{
                echo "deployed successfully!"
                echo "this is a testing success"
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

