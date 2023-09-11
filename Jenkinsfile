pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "mini-k8s-code"
  }

  stages {
    stage("Test") {
      agent {
        docker {
            image 'python:3.11.5-slim-bullseye'
            args '-u 0:0 -v /tmp:/root/.cache'
        }
      }
      steps {
        echo "Testing image"
      }
      // steps {
      //   sh "pip install poetry"
      //   sh "poetry install"
      //   sh "poetry run pytest"
      // }
    }

    stage("Build image") {
      agent {
        node {
            label 'built-in'
        }
      }
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
   
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
        }

        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
        sh "docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}"
        script {
            if (GIT_BRANCH ==~ /.*main.*/) {
                sh "docker tag ${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                sh "docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE}:latest"
            }
        }
        //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
      }
    }

      
    // stage('Trigger ManifestUpdate') {
    //     echo "Triggering mini k8s mainifest"
    //     build job: 'mini-k8s-mainfest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
    // }
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}
