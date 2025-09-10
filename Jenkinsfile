pipeline {
    agent any

    environment {
        REGISTRY     = "docker.io"
        IMAGE_NAME   = "server"
        IMAGE_TAG    = "latest"
        SERVER_PORT  = "8085"
        DOCKERHUB_CREDENTIALS = "creds"
    }

    stages {
        stage('Checkout') {
            steps {a
                git branch: 'master', url: 'https://github.com/Curiousgoal202/new-python-pro1.git'
            }
        }

        stage('Build') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                sh 'pytest || true'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            docker tag \$IMAGE_NAME:\$IMAGE_TAG \$DOCKER_USER/\$IMAGE_NAME:\$IMAGE_TAG
                            docker push \$DOCKER_USER/\$IMAGE_NAME:\$IMAGE_TAG
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                docker stop webserver || true
                docker rm webserver || true
                docker run -d --name webserver -p $SERVER_PORT:80 $IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        stage('Health Check') {
            steps {
                              sh '''
                sleep 5
                STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${SERVER_PORT}/)
                if [ "$STATUS" -ne 200 ]; then
                    echo "❌ Deployment failed with status $STATUS"
                    exit 1
                fi
                echo "✅ Deployment successful, status $STATUS"
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
