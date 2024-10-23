pipeline{
    agent any
    options{skipDefaultCheckout()}
    environment{
        github_url          = "ghcr.io"
        github_auth         = credentials('github_auth')
        namespace           = "supawit21"
        image_name          = "${github_url}/${namespace}/devops-assignment"
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
                sh "docker build --build-arg service_name=${application_name} -t ${image_name}:${image_tag} ."
            }
        }
        stage('Push-Image'){
            steps{
                sh """
                    docker login ${github_url} -u ${github_auth_USR} -p ${github_auth_PSW}
                    docker push ${image_name}:${image_tag}
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

                    sh 'envsubst < ./helm/values.yaml > ./helm/demo-values.yaml'
                }
            }
        }
        stage('Deploy'){
            steps{
                script{
                    sh "helm upgrade --install ${application_name} ./helm --values ./helm/demo-values.yaml"
                }
            }
        }
    }
}