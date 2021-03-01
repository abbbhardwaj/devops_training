pipeline {
    agent any
 	tools{
 		maven 'Maven_3.6.3'
 	}
    stages {
    	stage('Initialize') {
            steps {
                echo "PATH = ${PATH}"
                echo "M2_HOME = ${M2_HOME}"
            }
        }
        stage('Checkout') {
            steps {        
            
             echo "parameter : ${testParam}"
            checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [[$class: 'CheckoutOption', timeout: 5], [$class: 'CloneOption', noTags: false, reference: '', shallow: false, timeout: 5]], userRemoteConfigs: [[url: 'https://github.com/abbbhardwaj/devops_training.git']]]) 
                  echo 'Checkout source code from git' 
            }
        }
        
       stage(' Parallel Quality and Security Check') {
        parallel {
        	stage('Quality Check'){
        	 agent any 
             steps {
            	sh '/usr/local/bin/newman -v'
                echo 'QA verified'
           		 }
               }
        stage('Security Check') {
        	agent any
            steps {
            	dependencyCheck additionalArguments: '--scan=. --format=HTML', odcInstallation: 'OWASP-Dependency-Check'
                echo 'All security checks done'
             }
            }
          }
        }
        stage('Build Push App') {
    
         //docker { image 'springbootimage:latest' }
            steps {
                sh "mvn clean install"
               // sh "docker build -t springbootimage:latest ."
                echo "docker build done"
                
                //sh "docker images"
                echo "All docker images present on node"
            }
        }   
        stage('Kill previous deployment') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS') {
                    sh "fuser -k 8083/tcp"
                }
            }
        }

        stage('Deploy') {
            steps {
            	echo 'sleep for 10 seconds'
            	sleep(time:10,unit:"SECONDS")
            	//sh "docker run -d springbootimage:latest"
                sh "JENKINS_NODE_COOKIE=dontKillMe nohup java -jar ./target/spring-boot-rest-2-0.0.1-SNAPSHOT.jar &"
                echo 'Deployment done'
                sleep(time:10,unit:"SECONDS")
            }
        }
        stage('Post Deployment Check') {
            steps {
                sh "/usr/local/bin/newman run abhinav.postman_collection.json -r html,cli"
                echo 'All deployment check done'
            }
        }  
        
        stage('push notifications'){
        	steps{
         		office365ConnectorSend (message: 'Manual test', webhookUrl: 'https://fisglobal.webhook.office.com/webhookb2/46481ee8-19ae-4f09-9c08-b03fbd19bec5@e3ff91d8-34c8-4b15-a0b4-18910a6ac575/JenkinsCI/c033c9f798554aea8f07d29b974f99ad/46481ee8-19ae-4f09-9c08-b03fbd19bec5')
        }
      }
	}