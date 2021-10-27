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
                    sh "ls && docker-compose build && docker-compose push"
                }
            }
            stage('Deploy App'){
                steps{
                    sh "docker-compose up -d"
                }
            }
            stage('Kubernetes Setup'){
                steps{
                    script{
                        sh "cd kubernetes && ls -al && kubectl apply -f frontend.yaml && kubectl apply -f backend.yaml && kubectl apply -f nginx.yaml"
                    }
                }
            }
            stage('Get load-balance IP'){
                steps{
                    sh "kubectl get services"
                }
            }
        }
}