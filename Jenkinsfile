pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/harshrajurkar/node-hello.git'
            }
        }

        stage('Upload index.html to S3') {
            steps {
                withAWS(region: 'ap-south-1', credentials: 'aws-creds') {
                    s3Upload bucket: 'my-frontend-site-node',
                             file: 'index.html',
                             path: "index.html"
                }
            }
        }
    }

    post {
        success {
            echo "index.html uploaded to S3 successfully!"
        }
        failure {
            echo "Upload failed!"
        }
    }
}