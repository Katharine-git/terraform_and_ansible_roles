pipeline{

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
    }

    agent any
    stages {
        stage('checkout') {
            steps {
                
                git 'https://github.com/Katharine-git/terraform_and_ansible_roles.git'
            }
        }  
        stage('Terraform init'){
            steps{
                sh label: '', script: 'cd terraform'
                sh label: '', script: 'terraform init'
            }
        }
        stage('Terraform plan'){
            steps{
                sh label: '', script: 'terraform plan'
            }
        }
        stage('terraform apply'){
            steps{
                sh label: '', script: 'terraform apply --auto-approve'
            }
        }

        stage('invoke ansiblle-playbook'){
            steps{
                ansiblePlaybook credentialsId: 'aws-private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'hosts.ini', playbook: 'roles.yml'
            }
        
        }
    }
}