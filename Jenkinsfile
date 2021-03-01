pipeline {
    agent {  dockerfile true }
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
        
            steps {
                sh "mvn clean install"
                sh "docker info "
               // sh "docker build -t springbootimage:latest ."
                echo "docker build done"
                
                //sh "docker images"
                echo "All docker images present on node"
            }
        }   
        stage('Kill previous deploy ment') {
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
        
    }
  post {
    always {
    sh label: '', script: '''cd /newman
                                tar -czf report.html output'''
	emailext mimeType: 'text/html',
        subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}",
        body: """
          <html><body>
          <div>Job: ${env.JOB_NAME}</div>
          <div>Build ID: ${env.BUILD_NUMBER}</div>
          <div>Status: ${currentBuild.currentResult}</div>
          <div>More info at: ${env.BUILD_URL}</div>
          </body></html>
        """,
        to: """abhinav.bhardwaj@fisglobal.com""",
        attachLog: true,
        compressLog: false,
        recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']]
}
}
}