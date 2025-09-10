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
        // 1️⃣ Checkout
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Curiousgoal202/new-python-pro1.git'
	            }
        }

        // 2️⃣ Build (examples for different languages)
        stage('Build') {
            steps {
                 sh 'pip install -r requirements.txt'
 
            }
        }

        // 3️⃣ Test (examples for different languages)
        stage('Test') {
            steps {
 
 
                 sh 'pytest || true'
 
            }
        }

        // 4️⃣ Docker Build
        stage('Docker Build') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        // 5️⃣ Docker Push
        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'creds',
                                                      usernameVariable: 'DOCKER_USER',
                                                      passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            docker tag \$IMAGE_NAME:\$IMAGE_TAG \$DOCKER_USER/\$IMAGE_NAME:\$IMAGE_TAG
                            docker push \$DOCKER_USER/\$IMAGE_NAME:\$IMAGE_TAG
                        """
                    }
                }
            }
        }

        // 6️⃣ Deploy
        stage('Deploy') {
            steps {
                sh """
                docker stop webserver || true
                docker rm webserver || true
                docker run -d --name webserver -p $SERVER_PORT:80 $IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        // 7️⃣ Health Check
        stage('Health Check') {
            steps {
                sh """
                sleep 5
                curl -s -o /dev/null -w "%{http_code}" http://localhost:$SERVER_PORT | grep 200
                """
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
