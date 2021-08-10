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
                    script: cd terraform
                    script: 'terraform init'
                }
            }
            stage('Terraform plan'){
                steps{
                    script: cd terraform
                    script: 'terraform plan'
                }
            }
            stage('terraform apply'){
                steps{
                    script: cd terraform
                    script: 'terraform apply --auto-approve'
                }
            }
            stage{
                steps('invoke ansiblle-playbook'){
                    ansiblePlaybook credentialsId: 'aws-private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'hosts.ini', playbook: 'roles.yml'
                }
            
            }
        }
}