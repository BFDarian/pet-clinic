# Pet-Clinic Deployment

<Intro piece>

## Contents
- [Technologies](#Technologies)
- [Prerequisites](#Prerequisites)
- [Instructions](#Instructions)
- [Planning](#Planning)
- [Risk Assessment](#Risk-Assessment)
- [Contributors](#Contributors)

## Technologies
 
 The following technologies were used in the creation of this project.

 - Terraform
 - Jenkins
 - Docker
 - Kubernetes

## Prerequisites

Before attempting to run

## Terraform

The Terraform deployment will consist of:

- 1 VPC 
- 1 Public Subnet hosting an EC2 instance
- 2 Private Subnets hosting the RDS instance
- 3 Private Subnets hosting the EKS cluster
- 1 Internet Gateway
- 1 NAT Gateway
- Route Tables for each of the subnets
- 1 EKS Cluster containing 1 Auto-Scaling Worker Node Group
- 1 EC2 instance hosting the deployment stage
- 1 RDS instance

![Terraform-Model](https://github.com/BFDarian/pet-clinic/blob/documentation/images/Terraform-model.JPG)

## Instructions ##  

### Containerisation ###  
Docker aids in the creation of local development environments. In this case is is neccessary to create more than one container for the application; rest angular and nginx containerised using several Docker files. 
A creation of a new docker angular container was essential in order to connect the backend and front end of the application using an njinx reverse proxy to route data to and from a private datastore to a desired open internet port/web app.
The creation of a docker Compose doccument allowing you to use a YAML files to operate multi-container applications at once was paramount. with this, we had set the desired amount of 
containers counts, their builds, and storage designs, and then with a single set of commands we build, run and configure all the containers.
these containers will be pulled and accessed via our jenkins webhook in order to automate the task.

### install.sh ###  
Within the terraform ec2 module, a call is made to run the required .sh script
The install.sh script runs the necessacy commads on the created ec2 instance allowing for the automated installation of the needed technologies including these steps:  

Docker is installed and is needed inorder to run kubectl for the connection between kubernetees  
![docker-install](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-install.PNG)  

Compose is a seperate tool from Docker, so Docker compose must be installed inorder to docker-compose up and run the application  
![docker-compose-install](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-install.PNG)  

The docker compose file to be run will be listening on the identified port  

![docker-compose-yaml](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-compose-yaml.PNG)

The product of the docker compose while running on localhost  

![docker-compose-up-product](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-compose-up-product.PNG)  

kubectl is pulled and installed onto the machine inorder for the jenkins pipeline to be able to execute kubernetes scripts  
![kubectl-install](https://github.com/BFDarian/pet-clinic/blob/documentation/images/kubectl-install.PNG)

Docker and kubectle is then setup   
![docker-kube-setup](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-kube-setup.PNG)  

Jenkins is then installed onto the ec2 and jenkins user is created with the dependancies with the initialAdminPassword stored in jenkins/.jenkins/secrets/initialAdminPassword  
![jenkins-setup](https://github.com/BFDarian/pet-clinic/blob/documentation/images/jenkins-setup.PNG)  

Jenkins will run the docker compose from the docker compose within the registry pulled down from git, if any changes are made the webhook will activate and update the docker images and run those changed containers  


### Kubernetes ###

For the creation of the eks cluser we used Terraform to initialise and build it within aws. The cluser we created had two worker nodes that would contain the pods for the application. For the application an nginx Load balancer was used with two seperate cluserIP deployments, one for the frontend and one for the backend. From the nginx.yaml file we use a reverse proxy to manage the incoming traffic and distribute the data to the correct container. The frontend and backend retrieve their respect images from dockerhub and become accessible on their specified ports.

### Jenkins ###

The processes of creating a CI pipeline in our project was done through the Jenkins VM Container. Inside this machine, we set up Jenkins with an admin and password, and then set up a pipeline job to run our Jenkinsfile. The setup of this was done manually, though attempted automatically with the use of shellscript.  

When in the Jenkins vm, certain credentials where necessary to create the job successfully. With the use of the Docker credentials, we could change an image and push the new image to Dockerhub. We also needed to set up the 'sudo su' command to change permissions, both on obtaining the 'initialadminpassword' for Jenkins, and also to be able to run the configure file and set up Keys for access to AWS.  

Our initial environment variables where to contain the docker login credentials on the Jenkins VM, this has been done to be recognised within our log in shellscript.  

```
pipeline{
    agent any
    environment {
        app_version = 'v1'
        username = credentials('username')
        password = credentials('password')
```
---
Our Jenkinsfile was broken up into 5 stages which where run through on the build of the Jenkins job.

1. First we had to set up the login to docker for access to the images.
```}
stages{
    stage('Docker Login'){
        steps{
            sh 'docker login -u "{env.username}" -p "{env.password}" '
        }
    }
```
2. Then was the initial build and push up to Dockerhub for any updates done to the container images.
```

stage('Tag & Push Image'){
    steps{
        sh "docker-compose build && docker compose push"
        }
    }
```
3. This stage deploys the docker-compose containers.
``` 
stage('Deploy App'){
steps{
    sh "docker-compose up -d"
}
```
4. Next is to locate the filepath within the repository and at the layer of Kubernetes, deploy the EKS cluster and pods.
```
}
stage('Kubernetes Setup'){
steps{
    sh "cd kubernetes && kubectl apply -f ."
}
```
5. Once this section is done, there is then a set time for the step to wait before retrieving this information, as it will take time to spin up and give the necessary IP address to locate our application on port 80.
```
}
stage('Get load-balance IP'){
steps {
    sleep time: 180, unit: 'SECONDS'
    sh "kubectl get services"
}
```

### Jenkins vm setup
First to retireve the jenkins intialAdminPassword you must ssh on to the vm and from there follow these steps:
```
1. sudo su jenkins
2. cd ..
3. cat jenkins/.jenkins/secrets/initialAdminPassword
```

Afterwards you then need to do aws configure and enter the credentials. 

Then finally do 
```
aws eks --region eu-west-1 update-kubeconfig --name cluster
```
---


## Planning
 Trello board
![Trello-board](https://github.com/BFDarian/pet-clinic/blob/documentation/images/TrelloBoard.png)


## Risk Assessment
![Risk Assessment](https://github.com/BFDarian/pet-clinic/blob/documentation/images/Risk_assessment.png)

## Burn Down Chart
![Burn-Down-Chart](https://github.com/BFDarian/pet-clinic/blob/documentation/images/Burn-Down-Chart.JPG)


 ## Contributors
This project was put together by [Abel](https://github.com/MrLucien-Johnson), [Ben](https://github.com/BFDarian), [Luis](https://github.com/LSoares1), [Sean](https://github.com/Arcticleech) and [Rob](https://github.com/mauvesky1)
