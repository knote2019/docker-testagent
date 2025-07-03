pipeline {
    agent none
    stages {
        stage('Start vLLM Servers') {
            parallel {
                stage('host1') {
                    agent { label 'BI150-X86-U-1.45' }
                    options {
                        timestamps()
                        ansiColor('xterm')
                    }
                    stages {
                        stage('Test1') {
                            steps {
                                sh """
                                    sleep 12000
                                """
                            }
                        }
                    }
                    post {
                        always {
                            echo 'host1 post'
                        }
                    }
                }

                stage('host2') {
                    agent { label 'BI150-X86-U-1.46' }
                    options {
                        timestamps()
                        ansiColor('xterm')
                    }
                    stages {
                        stage('Test2') {
                            steps {
                                sh """
                                    sleep 12000
                                """
                            }
                        }
                    }
                    post {
                        always {
                            echo 'host2 post'
                        }
                    }
                }
            }
        }

        stage('Run Distributed Test') {
            agent { label 'BI150-X86-U-1.22' } // 专用测试节点
            steps {
                script {
                    sh """
                        sleep 12000
                    """
                }
            }
        }
    }
}
