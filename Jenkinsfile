pipeline{
        agent any
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