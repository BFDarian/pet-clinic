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
                        withKubeConfig([credentialsId: 'root', serverUrl: 'https://E1045E516BAB8BB936D9F4188FA7ABC8.sk1.eu-west-1.eks.amazonaws.com']) {
                        sh "cd kubernetes && kubectl apply -f ."
                        }    
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