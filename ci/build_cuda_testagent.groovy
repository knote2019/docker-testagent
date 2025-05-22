def CI_NODE_AMD64_LABEL = params.CI_NODE_AMD64_LABEL.trim()

/*****************************************************************
 * common.
 * **************************************************************/
def build_torch_testagent = params.build_torch_testagent
def build_megatron_testagent = params.build_megatron_testagent
def build_vllm_testagent = params.build_vllm_testagent
def build_test_testagent = params.build_test_testagent

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
                 * common.
                 * **************************************************************/
                stage('core') {
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/core-image
                                docker pull 10.150.9.98:80/devops-nvidia/ubuntu22.04-dev-x86_64:master
                                docker build --force-rm --tag 10.150.9.98:80/devops-nvidia/ubuntu22.04-testagent:master --file ubuntu22.04-testagent.dockerfile .
                                docker push 10.150.9.98:80/devops-nvidia/ubuntu22.04-testagent:master
                            """
                        }
                    }
                }

                /*****************************************************************
                 * base.
                 * **************************************************************/
                stage('torch') {
                    when { expression { params.build_torch_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e0-framework-base
                                docker build --build-arg FORCE_BUILD=\$(date +%s) --force-rm --tag 10.150.9.98:80/devops-nvidia/torch-v2.4.1:master --file torch-v2.4.1.dockerfile .
                                docker push 10.150.9.98:80/devops-nvidia/torch-v2.4.1:master
                                docker images | grep devops-nvidia
                            """
                        }
                    }
                }

                stage('megatron') {
                    when { expression { params.build_megatron_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e3-framework-lm-training
                                docker build --force-rm --tag 10.150.9.98:80/devops-nvidia/megatron-v0.8.0:master --file megatron-v0.8.0.dockerfile .
                                docker push 10.150.9.98:80/devops-nvidia/megatron-v0.8.0:master
                                docker images | grep devops-nvidia
                            """
                        }
                    }
                }

                stage('vllm') {
                    when { expression { params.build_vllm_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --build-arg FORCE_BUILD=\$(date +%s) --force-rm --tag 10.150.9.98:80/devops-nvidia/vllm-v0.6.3:master --file vllm-v0.6.3.dockerfile .
                                docker push 10.150.9.98:80/devops-nvidia/vllm-v0.6.3:master
                                docker images | grep devops-nvidia
                            """
                        }
                    }
                }

                stage('test') {
                    when { expression { params.build_test_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e5-test
                                docker build --force-rm --tag 10.150.9.98:80/devops-nvidia/vllm-v0.8.3:test --file vllm-v0.8.3.dockerfile .
                                docker push 10.150.9.98:80/devops-nvidia/vllm-v0.8.3:test
                                docker images | grep devops-nvidia
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
