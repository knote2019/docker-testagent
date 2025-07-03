def NODE_LABEL_MASTER = "BI150-X86-U-1.45"
def NODE_LABEL_SLAVE = "BI150-X86-U-1.46"
def DOCKER_IMAGE = "10.150.9.98:80/devops_tools/corex-testagent-ubuntu-x86_64:master"

pipeline {
    agent NODE_LABEL_SLAVE
    stages {
        stage("vllm_test") {
            steps {
                script {

                    sh """
                        docker run -itd -v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P --name corex-testagent 10.150.9.98:80/devops_tools/corex-testagent-ubuntu-x86_64:master
                    """

                    node(NODE_LABEL_MASTER) {
                        script{
                            def dockerImage = docker.image(DOCKER_IMAGE)
                            dockerImage.pull()
                            dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                                sh """
                                    sleep 12000
                                """
                            }
                        }
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
