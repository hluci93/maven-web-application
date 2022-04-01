//Define needed parameters

properties([
  parameters([
      string(defaultValue: './pom.xml', description: 'POM file used for deploying.', name: 'pom_file'),
      string(defaultValue: './target/maven-web-application.war', description: 'WAR file used for deploying.', name: 'war_file'),
      string(defaultValue: 'http://192.168.72.199:8082/artifactory/maven_repo', description: 'Repository used for deployment of the Artifact.', name: 'art_repo'),
      string(defaultValue: 'https://github.com/hluci93/maven-web-application', description: 'GitHub Repository used for importing configuration.', name: 'git_repo'),
      string(defaultValue: 'central', description: 'Repository id used for deployment of the Artifact..', name: 'repo_id'),
                 // USED FOR BUILD STAGE
      string(defaultValue: 'maven', description: 'Filter used as a label to remove old versions of images and containers.', name: 'filter'),
      string(defaultValue: 'second_project_maven_image', description: 'Image name used for this build.', name: 'imageName'),
      string(defaultValue: 'second_project_maven_container', description: 'Container name used for this build.', name: 'containerName'),
      string(defaultValue: '9090', description: 'Exposed port used in this build.', name: 'EXPOSED_PORT'),
      string(defaultValue: '8080', description: 'Port defined inside project.', name: 'INSIDE_PORT'),
                // USED FOR DEPLOYMENT TO CONTAINER STAGE                                
  ])
])


//START PIPELINE
pipeline {
    agent any

    tools {
        // Will Use maven version 3.8.5 defined with the same name.
        maven "3.8.5"
        //Git Default build
        git "Default"
    }
    
    options{
    timestamps()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '2', numToKeepStr: '5'))
    }


stages {
  stage("Get Git Code")
        {
            steps 
                {
                // Get code from GitHub repository
                git credentialsId: 'c9d8cdef-1edb-4e31-9682-ed6d205f722b', url: "${params.git_repo}"
                }
        } 
  stage("Build and Deploy Package")
        {
          stages{ 
            stage("Build package")
              {
                 steps
                 {
                 echo 'Building package'
                 sh 'mvn package'
                 }
              }
            stage("Deploy Package")    
            {
            steps
                { //Deploy to Artifactory
                echo 'Deploy package to Artifactory'
                sh """mvn deploy:deploy-file -DpomFile=${params.pom_file} -Dfile=${params.war_file} -Durl=${params.art_repo} -DrepositoryId=${params.repo_id} -DuniqueVersion=true"""
                }
            }
            
        }
      }
  stage('Build Docker container')
        {          
          stages
           {
            stage("Cleanup")
             { 
            steps
                { //CLEANUP
                echo 'Clean system of old images and containers'
                script
                {
                  def nr_cont = sh """docker ps -a --filter "label=type=${params.filter}" | wc -l"""
                  if ( nr_cont != 1){
                      echo "test"
                      sh """docker rm \$(docker stop \$(docker ps -a --filter "label=type=${params.filter}" --format="{{.ID}}"))"""
                      }
                 sh """docker image prune -f --filter label=type=${params.filter}"""
                }            
                
                }
             }
             stage("Build and Deploy Container")
              {
               steps
                { //Build image and deploy container
                echo 'Deploy container'                   
                sh """docker build -t ${params.imageName}:${BUILD_NUMBER} ."""
                                sh """docker run -d -p ${params.EXPOSED_PORT}:${params.INSIDE_PORT} --name ${params.containerName} ${params.imageName}:${BUILD_NUMBER}"""
                  

                }
              }
        }
      }   
}//Stages Closing

}//Pipeline closing
