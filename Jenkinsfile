pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE_NAME = 'melkamu372/php-todo-app'
    }

    stages {
        stage("Initial cleanup") {
            steps {
                dir("${WORKSPACE}") {
                    deleteDir()
                }
            }
        }

        stage('SCM Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/melkamu372/tooling-containerization.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: 'main'
                    // Sanitize branch name for Docker tag
                    def sanitizedBranchName = branchName.replaceAll('/', '-').toLowerCase()
                    def buildTag = "${sanitizedBranchName}-0.0.${env.BUILD_NUMBER}"
                    def buildCommand = "docker build -t ${DOCKER_IMAGE_NAME}:${buildTag} ."
                    if (isUnix()) {
                        sh buildCommand
                    } else {
                        bat buildCommand
                    }
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    if (isUnix()) {
                        sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    } else {
                        bat "echo %DOCKERHUB_CREDENTIALS_PSW% | docker login -u %DOCKERHUB_CREDENTIALS_USR% --password-stdin"
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: 'main'
                    // Sanitize branch name for Docker tag
                    def sanitizedBranchName = branchName.replaceAll('/', '-').toLowerCase()
                    def buildTag = "${sanitizedBranchName}-0.0.${env.BUILD_NUMBER}"
                    def pushCommand = "docker push ${DOCKER_IMAGE_NAME}:${buildTag}"
                    if (isUnix()) {
                        sh pushCommand
                    } else {
                        bat pushCommand
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenUnstable: true, deleteDirs: true)
                script {
                    if (isUnix()) {
                        sh 'docker logout'
                    } else {
                        bat 'docker logout'
                    }
                }
            }
        }
    }
}
