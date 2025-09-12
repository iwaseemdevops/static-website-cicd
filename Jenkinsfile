pipeline {
    agent any
    
    environment {
        EC2_HOST = '65.2.70.23' // Replace with your EC2 IP
        SSH_CREDENTIALS_ID = 'ec2-ssh-key'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/iwaseemdevops/static-website-cicd.git'
                
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t static-website .'
                }
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                script {
                    // Save the Docker image as a tar file
                    sh 'docker save static-website > static-website.tar'
                    
                    // Transfer the image to EC2
                    sshagent([SSH_CREDENTIALS_ID]) {
                        sh """
                            scp -o StrictHostKeyChecking=no static-website.tar ec2-user@${EC2_HOST}:/home/ec2-user/
                            ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} \
                            "docker load < /home/ec2-user/static-website.tar && \
                            docker stop static-container || true && \
                            docker rm static-container || true && \
                            docker run -d -p 8081:80 --name static-container static-website"
                        """
                    }
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    // Wait a bit for the container to start
                    sleep 10
                    
                    // Verify the website is accessible
                    sh "curl -f http://${EC2_HOST}/ || exit 1"
                    
                    echo "Deployment verified successfully!"
                }
            }
        }
    }
    
    post {
        always {
            // Clean up workspace
            deleteDir()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}