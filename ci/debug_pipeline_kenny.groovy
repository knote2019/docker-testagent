def NODE_LABEL_MASTER = "BI150-X86-U-1.45"
def NODE_LABEL_SLAVE = "BI150-X86-U-1.46"
def DOCKER_IMAGE = "10.150.9.98:80/devops_tools/corex-testagent-ubuntu-x86_64:master"
def dockerImage = docker.image(DOCKER_IMAGE)

pipeline {
    agent { node { label NODE_LABEL_SLAVE } }
    stages {
        stage('run_test') {
            steps {
                script{
                    dockerImage.pull()
                    dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                        sh """
                            echo "kkk"
                        """
                        node(NODE_LABEL_MASTER) {
                            script{
                                dockerImage.pull()
                                dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                                    sh """
                                        sleep 120
                                    """
                                }
                            }
                        }
                        sh """
                            echo "mmm"
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
