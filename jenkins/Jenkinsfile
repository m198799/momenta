node {  
    stage('Test') { 
        sh 'mvnw verify'
    }
    stage('Build') { 
        sh 'mvnw -Pprod clean verify' 
    }
    stage('Update') { 
        sh 'aws-s3 public-devops-software-package target/*.jar umsl.jar'
    }
}
