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
                mvn verify
                docker compose up 
                """}
            }
        }
        stage ("E2E test"){
            steps {
                sh" sleep 10"
                sh "curl telnet://44.204.183.150:8083"
            }
        }
        stage ("Destroy test Env") {
            steps {
                sh "docker compose down"
            }
        }
    }
    post {
        always {
            sh "docker compose down"
            sh "docker stop tedsearch"
            sh "docker rm tedsearch"
            sh "docker stop nginx-proxy"
            sh " docker rm ningx-proxy"
        }
    }
}