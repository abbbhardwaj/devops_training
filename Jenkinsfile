pipeline {
    agent any
 
    stages {
        stage('Checkout') {
            steps {        
            			echo "parameter : ${testParam}"
             echo 'Checkout source code from git'
            }
        }
        stage('Quality Check') {
            steps {
            
                echo 'QA verified'
            }
        }
        stage('Security Check') {
            steps {
            	dependencyCheck additionalArguments: '--scan=. --format=HTML', odcInstallation: 'OWASP-Dependency-Check'
                echo 'All security checks done'
            }
        }
        stage('Build Push App') {
            steps {
               sh "mvn clean install"
            }
        }
         stage('Deploy') {
            steps {
                echo 'Deployment done'
            }
        }
         stage('Post Deployment Check') {
            steps {
                echo 'All deployment check done'
            }
        }
    }
}