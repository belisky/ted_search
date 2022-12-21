pipeline {
    agent any

    stages {
        stage("Build and Unit Tests") {
            steps {
                   withMaven(
                    maven: 'maven:3.6.2',
                    mavenLocalRepo: '.repository' 
                ){
                sh """
                mvn verify
                sudo docker compose up
                """}
            }
        }
        stage ("E2E test"){
            steps {
                sh "curl telnet://44.204.183.150:8083"
            }
        }
    }
}