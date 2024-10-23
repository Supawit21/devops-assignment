pipeline{
    agent none
    options{skipDefaultCheckout()}
    environment{
        github_url          = "ghcr.io"
        github_auth         = credentials('github_auth')
        namespace           = "Supawit21"
        image_name          = "devops-assignment"
        image_tag           = "demo-1.0"
        application_name    = "demo"
    }
    stages{
        stage('Checkout'){
            steps{
                checkout scm
            }
        }
        stage('Build-Image'){
            steps{
                bat "docker build --build-arg service_name=${image_name} -t ${github_url}/${namespace}/${image_name}:${image_tag} ."
            }
        }
        stage('Push-Image'){
            steps{
                bat """
                    docker login ${github_url} -u ${github_auth_USR} -p ${github_auth_PSW}
                    docker push ${github_url}/${namespace}/${image_name}:${image_tag}
                """
            }
        }
        stage('Prepare-File'){
            steps{
                script{
                    def servicepath   = readJSON file: './helm/service.json'
                    
                    servicepath[0].each { key, value ->
                        env."${key}" = value
                    }

                    bat 'envsubst < ./helm/values.yaml > ./helm/demo-values.yaml'
                }
            }
        }
        stage('Deploy'){
            steps{
                script{
                    bat 'helm upgrade --install demo ./helm --values ./helm/demo-values.yaml'
                }
            }
        }
    }
}