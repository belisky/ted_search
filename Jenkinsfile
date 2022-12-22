pipeline {
    agent any
     tools {
        maven 'maven3.6.2'
        jdk 'jdk_8'
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
                docker compose build --no-cache   
                docker compose up -d --wait             
                """
                
                }
            }
        }
        stage ("E2E test"){
            steps {
                
                echo "e2e test"
            }
        }
        stage ("Destroy test Env") {
            steps {
                sh "destroying test env"
            }
        }
    }
    post {
        always {
            cleanWs()
            sh "docker compose down --remove-orphans"
         
        }
    }
}