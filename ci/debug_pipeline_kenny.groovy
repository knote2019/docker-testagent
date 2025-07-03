def NODE_LABEL_MASTER = "BI150-X86-U-1.45"
def NODE_LABEL_SLAVE = "BI150-X86-U-1.46"
def DOCKER_IMAGE = "10.150.9.98:80/devops_tools/corex-testagent-ubuntu-x86_64:master"
def dockerImage = docker.image(DOCKER_IMAGE)

pipeline {
    agent none
    stages {
        stage('run_test') {
            steps {
                script{
                    dockerImage.pull()
                    dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                        sh """
                            echo "111"
                            sleep 120
                        """

                        script {
                            def parallelTasks = [:]
                            parallelTasks['slave'] = {
                                node(NODE_LABEL_SLAVE) {
                                    dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                                        sh "echo 222; ip a;  sleep 120"
                                    }
                                }
                            }
                            parallel(parallelTasks)
                        }

                        sh """
                            echo "333"
                            sleep 120
                        """
                    }
                }
            }
        }
    }
    post{
        always{
            script{
                cleanWs()
            }
        }
    }
}
