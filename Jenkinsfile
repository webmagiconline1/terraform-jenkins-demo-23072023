pipeline {
    agent any
    
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Select the environment: dev or prod')
        // choice(name: 'TFVARS_FILE', choices: ['dev.tfvars', 'prod.tfvars'], description: 'Select the .tfvars file')
        booleanParam(name: 'RUN_PLAN', defaultValue: true, description: 'Run Terraform plan')
        booleanParam(name: 'RUN_APPLY', defaultValue: false, description: 'Run Terraform apply')
        booleanParam(name: 'RUN_DESTROY', defaultValue: false, description: 'Run Terraform destroy')
    }
    
    stages {
        stage('Initialize') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Prepare Workspace') {
            when {
                expression { params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'prod' }
            }
            steps {
                script {
                    def workspace = params.ENVIRONMENT
                    sh "terraform workspace new ${workspace} || true"
                    sh "terraform workspace select ${workspace}"
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
                    if (fileExists(tfvarsFile)) {
                        sh "terraform plan -var-file=${tfvarsFile}"
                    } else {
                        error("Given variables file ${tfvarsFile} does not exist.")
                    }
                }
            }
        }
        
        stage('Apply') {
            when {
                expression { params.RUN_APPLY == true && (params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'prod') }
            }
            steps {
                script {
                    def tfvarsFile = params.ENVIRONMENT + '.tfvars'
                    if (fileExists(tfvarsFile)) {
                        sh "terraform apply -var-file=${tfvarsFile} -auto-approve"
                    } else {
                        error("Given variables file ${tfvarsFile} does not exist.")
                    }
                }
            }
        }
        
        stage('Destroy') {
            when {
                expression { params.RUN_DESTROY == true && (params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'prod') }
            }
            steps {
                script {
                    def tfvarsFile = params.ENVIRONMENT + '.tfvars'
                    if (fileExists(tfvarsFile)) {
                        sh "terraform destroy -var-file=${tfvarsFile} -auto-approve"
                    } else {
                        error("Given variables file ${tfvarsFile} does not exist.")
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}

def fileExists(filename) {
    return fileExistsInWorkspace(filename) || fileExistsInRoot(filename)
}

def fileExistsInWorkspace(filename) {
    return new File("${env.WORKSPACE}/${filename}").exists()
}

def fileExistsInRoot(filename) {
    return new File("${filename}").exists()
}
