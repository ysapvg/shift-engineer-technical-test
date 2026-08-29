pipeline {
    agent any

    environment {
        IMAGE = 'go-service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh '''
            docker build \
              --target builder \
              -t go-service-test .

            docker run --rm \
              go-service-test \
              go test ./...
        '''
            }
        }

        stage('Build Image') {
            steps {
                script {
                    env.VERSION = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    sh """
                        docker build \
                        --build-arg VERSION=${VERSION} \
                        -t ${IMAGE}:${VERSION} .
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
            docker run --rm \
              -v "$PWD:/app" \
              -w /app \
              golang:1.27-alpine \
              sh -c 'CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s -X main.version=$VERSION" -o go_service_hotfix .'

            docker cp go_service_hotfix go-service:/src
            docker restart go-service

            sleep 2
            curl http://host.docker.internal:8080
            '''
            }
        }
    }
}
