pipeline {
    agent any

    tools {
        // Will Use maven version 3.8.5 defined with the same name.
        maven "3.8.5"
    }
    
    options{
    timestamps()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '2', numToKeepStr: '5'))
    parameters([string(defaultValue: '${WORKSPACE}/pom.xml', description: 'POM file used for deploying.', name: 'pom_file'),
                 string(defaultValue: '${WORKSPACE}/target/maven-web-application.war', description: 'WAR file used for deploying.', name: 'war_file'),
                 string(defaultValue: 'http://192.168.72.199:8082/artifactory/maven_repo', description: 'Repository used for deployment of the Artifact.', name: 'repo_string'),
                 string(defaultValue: 'central', description: 'Repository id used for deployment of the Artifact..', name: 'repo_id')])
    }

options{
timestamps()
buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '5', daysToKeepStr: '', numToKeepStr: '5'))
}

stages{

  stage('CheckOutCode'){
    steps{
    git branch: 'development', credentialsId: '957b543e-6f77-4cef-9aec-82e9b0230975', url: 'https://github.com/devopstrainingblr/maven-web-application-1.git'
	
	}
  }
  
  stage('Build'){
  steps{
  sh  "mvn clean package"
  }
  }
/*
 stage('ExecuteSonarQubeReport'){
  steps{
  sh  "mvn clean sonar:sonar"
  }
  }
  
  stage('UploadArtifactsIntoNexus'){
  steps{
  sh  "mvn clean deploy"
  }
  }
  
  stage('DeployAppIntoTomcat'){
  steps{
  sshagent(['bfe1b3c1-c29b-4a4d-b97a-c068b7748cd0']) {
   sh "scp -o StrictHostKeyChecking=no target/maven-web-application.war ec2-user@35.154.190.162:/opt/apache-tomcat-9.0.50/webapps/"    
  }
  }
  }
  */
}//Stages Closing

post{

 success{
 emailext to: 'devopstrainingblr@gmail.com,mithuntechnologies@yahoo.com',
          subject: "Pipeline Build is over .. Build # is ..${env.BUILD_NUMBER} and Build status is.. ${currentBuild.result}.",
          body: "Pipeline Build is over .. Build # is ..${env.BUILD_NUMBER} and Build status is.. ${currentBuild.result}.",
          replyTo: 'devopstrainingblr@gmail.com'
 }
 
 failure{
 emailext to: 'devopstrainingblr@gmail.com,mithuntechnologies@yahoo.com',
          subject: "Pipeline Build is over .. Build # is ..${env.BUILD_NUMBER} and Build status is.. ${currentBuild.result}.",
          body: "Pipeline Build is over .. Build # is ..${env.BUILD_NUMBER} and Build status is.. ${currentBuild.result}.",
          replyTo: 'devopstrainingblr@gmail.com'
 }
 
}


}//Pipeline closing
