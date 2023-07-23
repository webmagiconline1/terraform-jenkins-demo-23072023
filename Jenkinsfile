pipeline {
    agent any
    
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Select the environment: dev or prod')
        booleanParam(name: 'RUN_PLAN', defaultValue: true, description: 'Run Terraform plan')
        booleanParam(name: 'RUN_APPLY', defaultValue: false, description: 'Run Terraform apply')
        booleanParam(name: 'RUN_DESTROY', defaultValue: false, description: 'Run Terraform destroy')
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage('Prepare Workspace') {
            when {
                expression { params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'prod' }
            }
            steps {
                script {
                    def workspace = params.ENVIRONMENT
                    
                    dir('terraform') {
                        def workspaceStatus = sh(returnStatus: true, script: "terraform workspace select ${workspace}")
                        if (workspaceStatus != 0) {
                            sh "terraform workspace new ${workspace}"
                        }
                    }
                }
            }
        }
        
        stage('Plan') {
            when {
                expression { params.RUN_PLAN == true && (params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'prod') }
            }
            steps {
                script {
                    def tfvarsFile = params.ENVIRONMENT + '.tfvars'
                    def workspace = params.ENVIRONMENT
                    
                    dir('terraform') {
                        if (fileExists(tfvarsFile)) {
                            sh "terraform workspace select ${workspace}"
                            sh "terraform plan -var-file=${tfvarsFile}"
                        } else {
                            error("Given variables file ${tfvarsFile} does not exist.")
                        }
                    }
                }
            }
        }
        
        // Rest of the stages (Apply and Destroy) follow a similar pattern as Plan
        // ...
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
