pipeline {
    agent any

    environment {
        SOURCE_NETWORK_DRIVE_LETTER = 'Z:'
        SOURCE_NETWORK_PATH = '\\server\source_share'
        DESTINATION_NETWORK_DRIVE_LETTER = 'Y:'
        DESTINATION_NETWORK_PATH = '\\server\destination_share'
        USERNAME = 'your_username'
        PASSWORD = 'your_password'
        PYTHON_SCRIPT = 'copy_files.py'
    }

    stages {
        stage('Map Source Network Drive') {
            steps {
                script {
                    // Map the source network drive
                    bat "net use ${SOURCE_NETWORK_DRIVE_LETTER} ${SOURCE_NETWORK_PATH} /user:${USERNAME} ${PASSWORD}"
                }
            }
        }

        stage('Map Destination Network Drive') {
            steps {
                script {
                    // Map the destination network drive
                    bat "net use ${DESTINATION_NETWORK_DRIVE_LETTER} ${DESTINATION_NETWORK_PATH} /user:${USERNAME} ${PASSWORD}"
                }
            }
        }

        stage('Access Files') {
            steps {
                script {
                    // Run a Python script to copy files
                    sh "python ${PYTHON_SCRIPT} ${SOURCE_NETWORK_DRIVE_LETTER} ${DESTINATION_NETWORK_DRIVE_LETTER}"
                }
            }
        }
    }

    post {
        always {
            // Unmap the source network drive after the job is completed
            script {
                bat "net use ${SOURCE_NETWORK_DRIVE_LETTER} /delete"
            }
            
            // Unmap the destination network drive after the job is completed
            script {
                bat "net use ${DESTINATION_NETWORK_DRIVE_LETTER} /delete"
            }
        }
    }
}
