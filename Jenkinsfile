pipeline {
    agent any
     tools {
        maven 'maven3.6.2'
        jdk 'jdk_8'         
        terraform "terraform11"
    
    }

    stages {
        stage("Build and Unit Tests") {
            steps {
                   withMaven(
                    maven: 'maven3.6.2',
                    mavenLocalRepo: '.repository' 
                ){
                sh """
                cleanWs()
                docker compose down                 
                docker compose -p ts build --no-cache   
                docker compose -p ts up -d --wait             
                """
                
                }
            }
        }
        stage ("E2E test"){
            steps {
                
                sh "curl telnet://52.205.252.207:8083"
            }
        }
        stage ("Deploy Images To ECR") {
            steps {
                sh "./push2ecr.sh"
            }
        }
        stage ("Start Prod EC2 Server") {
            steps {
                  withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "aws-cred",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
           
                sh "rm -rf .terraform"
                sh "terraform init -migrate-state"  
                sh "terraform workspace new tedsearch-${BUILD_NUMBER}"              
                sh "terraform apply --auto-approve"              
            
        }}}
            stage ("Smoke Tests") {
            steps {
                sh '''
                ip="${head -n 1 public_ip.txt}"
                curl telnet://${ip}:8083
                '''
            }
        }
    }
    post {
        always {
          
            sh "docker compose down --remove-orphans"
            echo "taking down the terraform"
            sh """
            terraform workspace select tedsearch-${BUILD_NUMBER}
            terraform destroy --auto-approve || true
            """
             
            cleanWs()
         
        }
    }
}