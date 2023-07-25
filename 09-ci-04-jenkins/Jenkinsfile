pipeline {
    agent {
        label 'linux'
    }
    stages {
        stage('Get role from github') {
            steps{
                git branch: 'main', credentialsId: 'none', url: 'https://github.com/ArsalanSan/ansible_vector_role.git'
            }
        }
        stage('Run Molecule'){
            steps{
                sh 'molecule test'
            }
        }
    }
}
