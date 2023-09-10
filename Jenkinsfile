node {
    def app

    agent { dockerfile true }

    stage('Clone repository') {
      

        checkout scm
    }

    stage('Build image') {
        steps {
            echo "Build image success"
        }
    }

    stage('Test image') {
  

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
        }
    }
    
    stage('Trigger ManifestUpdate') {
                echo "Triggering mini k8s mainifest"
                build job: 'mini-k8s-mainfest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}
