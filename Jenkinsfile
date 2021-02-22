pipeline{
    agent any
    stages{
        stage("on_commit"){
            steps{
            echo "this is commit stage"
        }}
        stage("quality_check"){
            steps{
   
            echo "QA check"
        }
    }
        stage("security_check"){
            steps{
       
            echo "Security check"
        
    }}
        stage("build_push_app"){
            steps{
          
            echo "Build Push APP"
        }
    }
        stage("deploy_app"){
            steps{
            
            echo "Deploy APP"
        }
    }
        stage("post_dep_check"){
            steps{
            
            echo "Post Dep check"
        }
    }
}}