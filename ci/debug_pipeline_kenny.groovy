def NODE_LABEL_MASTER = "BI150-X86-U-1.45"
def NODE_LABEL_SLAVE = "BI150-X86-U-1.46"
def DOCKER_IMAGE = "10.150.9.98:80/devops_tools/corex-testagent-ubuntu-x86_64:master"
def dockerImage = docker.image(DOCKER_IMAGE)

pipeline {
    agent none
    stages {
        stage('Test on Slave') {
            agent { label NODE_LABEL_SLAVE }
            steps {
                dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                    sh "echo 111; ip a;  sleep 120"
                }
            }
        }
        stage('Test on Master') {
            agent { label NODE_LABEL_MASTER }
            steps {
                dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                    sh "echo 222; ip a;  sleep 120"
                }
            }
        }
        stage('Final Steps on Slave') {
            agent { label NODE_LABEL_SLAVE }
            steps {
                dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
                    sh "echo 333; ip a; sleep 120"
                }
            }
        }
    }

//     stages {
//         stage('run_test') {
//             steps {
//                 script{
//                     dockerImage.pull()
//                     dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
//                         sh """
//                             echo "111"
//                             sleep 120
//                         """
//                         node(NODE_LABEL_MASTER) {
//                             script{
//                                 dockerImage.pull()
//                                 dockerImage.inside("-v /dev:/dev -v /lib/modules:/lib/modules --privileged --shm-size 64g -v /stores:/stores -P") {
//                                     sh """
//                                         echo "222"
//                                         sleep 120
//                                     """
//                                 }
//                             }
//                         }
//                         sh """
//                             echo "333"
//                             sleep 120
//                         """
//                     }
//                 }
//             }
//         }
//     }
    post{
        always{
            script{
                cleanWs()
            }
        }
    }
}
