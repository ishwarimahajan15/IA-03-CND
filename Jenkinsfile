pipeline {
    agent any
    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    environment {
        IMAGE_NAME = 'jenkins-terraform-demo'
        IMAGE_TAG = 'ci'
        CONTAINER_NAME = 'jenkins-terraform-demo'
        APP_PORT = '5001'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'echo "Source revision: ${GIT_COMMIT:-unknown}"'
            }
        }
        stage('Test') {
            steps {
                sh '''
                    docker run --rm -v "$WORKSPACE/app:/workspace" -w /workspace python:3.12-slim \\
                      sh -c "pip install --quiet -r requirements.txt && python -m unittest -v"
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./app'
            }
        }
        stage('Terraform Validate') {
            steps {
                dir('infrastructure') {
                    sh 'terraform init -input=false'
                    sh 'terraform fmt -check'
                    sh 'terraform validate'
                    sh 'terraform plan -input=false -out=tfplan'
                }
            }
        }
        stage('Deploy with Terraform') {
            steps {
                dir('infrastructure') {
                    sh 'terraform apply -input=false -auto-approve tfplan'
                }
            }
        }
        stage('Smoke Test') {
            steps {
                sh '''
                    for attempt in $(seq 1 20); do
                      if curl --fail --silent http://127.0.0.1:${APP_PORT}/health; then
                        echo
                        exit 0
                      fi
                      sleep 2
                    done
                    echo "Application did not become healthy"
                    docker logs ${CONTAINER_NAME} || true
                    exit 1
                '''
            }
        }
    }
    post {
        success { echo 'CI/CD pipeline completed successfully.' }
        failure { echo 'Pipeline failed. Inspect the failed stage and console output.' }
        always { sh 'docker ps -a --filter name=${CONTAINER_NAME} || true' }
    }
}
