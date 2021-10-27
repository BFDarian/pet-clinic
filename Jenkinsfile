pipeline{
        agent any
        environment {
            app_version = 'v1'
            username = credentials('username')
            password = credentials('password')
        }
        stages{
            stage('Docker Login'){
                steps{
                    script{
                        docker.withRegistry('https://registry.hub.docker.com/', 'docker-hub-credentials')
                    }
                }
            }
            stage('Tag & Push Image'){
                steps{
                    sh "docker-compose build && docker compose push"
                }
            }
            stage('Deploy App'){
                steps{
                    sh "docker-compose up -d"
                }
            }
            stage('Kubernetes Setup'){
                steps{
                    sh "cd kubernetes && kubectl apply -f ."
                }
            }
            stage('Get load-balance IP'){
                steps{
                    sh "kubectl get services"
                }
            }
        }
}