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
                sh "JENKINS_NODE_COOKIE=dontKillMe nohup java -jar ./target/spring-boot-rest-2-0.0.1-SNAPSHOT.jar &"
                echo 'Deployment done'
            }
        }
        stage('Post Deployment Check') {
            steps {
                sh "/usr/local/bin/newman run abhinav_collection_1.postman_collection.json -r html,cli"
                echo 'All deployment check done'
            }
        }
    }
    post {
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