def CI_NODE_AMD64_LABEL = params.CI_NODE_AMD64_LABEL.trim()

/*****************************************************************
 * common.
 * **************************************************************/
def build_torch_testagent = params.build_torch_testagent
def build_vllm_testagent = params.build_vllm_testagent

pipeline {
    agent none
    stages {
        stage('x86_64'){
            agent { node { label CI_NODE_AMD64_LABEL } }
            options {
                timestamps ()
                ansiColor('xterm')
            }
            stages {
                /*****************************************************************
                 * torch.
                 * **************************************************************/
                stage('torch') {
                    when { expression { params.build_torch_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/framework
                                docker build --build-arg FORCE_BUILD=\$(date +%s) --force-rm --tag 10.150.9.98:80/devops_tools/torch-v2.4.1:master --file torch-v2.4.1.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/torch-v2.4.1:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                /*****************************************************************
                 * vllm.
                 * **************************************************************/
                stage('vllm') {
                    when { expression { params.build_vllm_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/framework
                                docker build --build-arg FORCE_BUILD=\$(date +%s) --force-rm --tag 10.150.9.98:80/devops_tools/vllm-v0.8.3:master --file vllm-v0.8.3.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/vllm-v0.8.3:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }
            }
            post{
                always{
                    cleanWs()
                }
            }
        }
    }
}
