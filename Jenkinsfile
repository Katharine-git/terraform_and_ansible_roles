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
                dir('terraform') {
                    sh 'terraform init -force-copy'
                    sh 'terraform plan' 
                    sh 'terraform apply --auto-approve'                  
                }
                
            }
        }
    }
}
