pipeline{
        agent any
        environment {
            username = credentials('username')
            password = credentials('password')
        }
        stages{
            stage('Docker Login'){
                steps{
                    sh 'docker login -u $username -p $password'
                }
            }
            stage('Tag & Push Image'){
                steps{
                    sh "ls && docker-compose build && docker compose push"
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