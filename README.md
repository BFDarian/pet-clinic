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

## Instructions

- Containerisation
Docker aids in the creation of local development environments. In this case is is neccessary to create more than one container for the application; rest angular and nginx containerised using several Docker files. 
A creation of a new docker angular container was essential in order to connect the backend and front end of the application using an njinx reverse proxy to route data to and from a private datastore to a desired open internet port/web app.
The creation of a docker Compose doccument allowing you to use a YAML files to operate multi-container applications at once was paramount. with this, we had set the desired amount of 
containers counts, their builds, and storage designs, and then with a single set of commands we build, run and configure all the containers.
these containers will be pulled and accessed via our jenkins webhook in order to automate the task.

- install.sh
within the terraform ec2 module, a call is made to run the required .sh script

the install.sh script runs the necessacy commads on the created ec2 instance allowing for the automated installation of the needed technologies
this includes:

docker is installed and is needed inorder to run kubectl for the connection between kubernetees

![docker-install](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-install.png)

Compose is a seperate tool from Docker, so Docker compose must be installed inorder to docker-compose up and run the application
![docker-compose-install](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-install.png)
![docker-compose-up-product](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-compose-up-product.png)
kubectl is pulled and installed onto the machine inorder for the jenkins pipeline to be able to execute kubernetes scripts
![kubectl-install](https://github.com/BFDarian/pet-clinic/blob/documentation/images/kubectl-install.png)
Docker and kubectle is then setup 
![docker-kube-setup](https://github.com/BFDarian/pet-clinic/blob/documentation/images/docker-kube-setup.png)
jenkins is then installed onto the ec2
jenkins user is created with the dependancies and initial password stored in secrets
![jenkins-setup](https://github.com/BFDarian/pet-clinic/blob/documentation/images/jenkins-setup.png)

jenkins will run the docker compose from the docker compose within the registry pulled down from git

if any changes are made the webhook will activate and update the docker images and run those inturn 


## Planning
 Trello board



## Risk Assessment



 ## Contributors
This project was put together by [Abel](https://github.com/MrLucien-Johnson) [Ben](https://github.com/BFDarian), [Luis](https://github.com/LSoares1), [Sean](https://github.com/Arcticleech) and [Rob](https://github.com/mauvesky1)