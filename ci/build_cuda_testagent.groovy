def CI_NODE_AMD64_LABEL = params.CI_NODE_AMD64_LABEL.trim()

def build_pytorch_testagent = params.build_pytorch_testagent

def build_libtorch_testagent = params.build_libtorch_testagent
def build_tensorrt_testagent  = params.build_tensorrt_testagent
def build_tvm_testagent  = params.build_tvm_testagent
def build_onnxruntime_testagent  = params.build_onnxruntime_testagent

def build_torchtitan_testagent = params.build_torchtitan_testagent
def build_torchtune_testagent = params.build_torchtune_testagent
def build_transformer_engine_testagent = params.build_transformer_engine_testagent
def build_megatron_testagent = params.build_megatron_testagent

def build_flashinfer_testagent = params.build_flashinfer_testagent
def build_cuformer_testagent = params.build_cuformer_testagent
def build_vllm_testagent = params.build_vllm_testagent
def build_tgi_testagent = params.build_tgi_testagent
def build_sglang_testagent = params.build_sglang_testagent
def build_lightllm_testagent = params.build_lightllm_testagent
def build_tensorrt_llm_testagent = params.build_tensorrt_llm_testagent

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
                stage('core') {
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/core-image
                                docker pull 10.150.9.98:80/devops_tools/ubuntu22.04-ide-x86_64:master
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/core-testagent:master --file core-testagent.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/core-testagent:master
                            """
                        }
                    }
                }

                stage('cuda') {
                    when { expression { params.build_cuda_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/cuda-testagent
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/cuda-v11.8:master --file cuda-v11.8.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/cuda-v11.8:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('pytorch') {
                    when { expression { params.build_pytorch_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e1-framework-sm-training
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/pytorch-v2.4.1:master --file pytorch-v2.4.1.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/pytorch-v2.4.1:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('libtorch') {
                    when { expression { params.build_libtorch_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e2-framework-sm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/libtorch-v2.4.1:master --file libtorch-v2.4.1.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/libtorch-v2.4.1:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('tensorrt') {
                    when { expression { params.build_tensorrt_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e2-framework-sm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/tensorrt-v9.2.0:master --file tensorrt-v9.2.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/tensorrt-v9.2.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('tvm') {
                    when { expression { params.build_tvm_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e2-framework-sm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/tvm-v0.17.0:master --file tvm-v0.17.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/tvm-v0.17.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('onnxruntime') {
                    when { expression { params.build_onnxruntime_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e2-framework-sm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/onnxruntime-v1.19.0:master --file onnxruntime-v1.19.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/onnxruntime-v1.19.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('torchtitan') {
                    when { expression { params.build_torchtitan_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e3-framework-lm-training
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/torchtitan-v0.1.0:master --file torchtitan-v0.1.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/torchtitan-v0.1.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('torchtune') {
                    when { expression { params.build_torchtune_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e3-framework-lm-training
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/torchtune-v0.2.1:master --file torchtune-v0.2.1.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/torchtune-v0.2.1:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('transformer-engine') {
                    when { expression { params.build_transformer_engine_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e3-framework-lm-training
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/transformer-engine-v1.7:master --file transformer-engine-v1.7.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/transformer-engine-v1.7:master
                                docker images | grep devops_tools
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
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/megatron-v0.8.0:master --file megatron-v0.8.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/megatron-v0.8.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('flashinfer') {
                    when { expression { params.build_flashinfer_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/flashinfer-v0.1.7:master --file flashinfer-v0.1.7.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/flashinfer-v0.1.7:master
                                docker images | grep devops_tools
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
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/vllm-v0.5.4:master --file vllm-v0.5.4.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/vllm-v0.5.4:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('tgi') {
                    when { expression { params.build_tgi_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/tgi-v2.1.1:master --file tgi-v2.1.1.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/tgi-v2.1.1:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('lightllm') {
                    when { expression { params.build_lightllm_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/lightllm-v1.0.0:master --file lightllm-v1.0.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/lightllm-v1.0.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('sglang') {
                    when { expression { params.build_sglang_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/sglang-v0.3.0:master --file sglang-v0.3.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/sglang-v0.3.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('cuformer') {
                    when { expression { params.build_cuformer_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/cuformer-v0.1.0:master --file cuformer-v0.1.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/cuformer-v0.1.0:master
                                docker images | grep devops_tools
                            """
                        }
                    }
                }

                stage('tensorrt_llm') {
                    when { expression { params.build_tensorrt_llm_testagent == true } }
                    steps {
                        script{
                            sh """
                                cd ${env.WORKSPACE}/e4-framework-lm-inference
                                docker build --force-rm --tag 10.150.9.98:80/devops_tools/tensorrt-llm-v0.12.0:master --file tensorrt-llm-v0.12.0.dockerfile .
                                docker push 10.150.9.98:80/devops_tools/tensorrt-llm-v0.12.0:master
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
