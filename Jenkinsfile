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
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        def loginCommand = "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        if (isUnix()) {
                            sh loginCommand
                        } else {
                            bat loginCommand
                        }
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: 'main'
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
