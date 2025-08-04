FROM 10.150.9.98:80/devops_tools/ubuntu22.04-testagent:master
#-----------------------------------------------------------------------------------------------------------------------
# install driver.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nvidia/NVIDIA-Linux-x86_64-555.42.02.run -P /tmp \
&& bash /tmp/NVIDIA-Linux-x86_64-555.42.02.run --extract-only --target /tmp/umd \
&& cp /tmp/umd/libcuda.so.555.42.02 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.555.42.02 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& cp /tmp/umd/libnvidia-ml.so.555.42.02 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.555.42.02 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so \
&& cp /tmp/umd/nvidia-smi /usr/bin \
&& pip install nvidia-ml-py \
&& pip install nvitop \
&& ldconfig \
&& rm -rf /tmp/* \
&& echo "end"

# install cuda.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_11.8.0_520.61.05_linux.run -P /tmp \
&& bash /tmp/cuda_11.8.0_520.61.05_linux.run --toolkit --silent \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-compute.desktop \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-systems.desktop \
&& sed -i "s,host-linux-x64/nsight-sys,host-linux-x64/nsys-ui,g" /usr/share/applications/nsight-systems.desktop  \
&& rm -f /usr/share/applications/nsight.desktop \
&& rm -f /usr/share/applications/nvvp.desktop \
&& rm -rf /tmp/* \
&& echo "end"
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

# install cudnn.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cudnn/cudnn-linux-x86_64-9.1.0.70_cuda11-archive.tar.xz -P /tmp \
&& tar -xf /tmp/cudnn-linux-x86_64-9.1.0.70_cuda11-archive.tar.xz -C /tmp \
&& cp -r /tmp/cudnn-linux-x86_64-9.1.0.70_cuda11-archive/include/* /usr/local/cuda/include \
&& cp -r /tmp/cudnn-linux-x86_64-9.1.0.70_cuda11-archive/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

# install nccl.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nccl/nccl_2.20.5-1+cuda11.0_x86_64.txz -P /tmp \
&& tar -xf /tmp/nccl_2.20.5-1+cuda11.0_x86_64.txz -C /tmp \
&& cp -r /tmp/nccl_2.20.5-1+cuda11.0_x86_64/include/* /usr/local/cuda/include \
&& cp -r /tmp/nccl_2.20.5-1+cuda11.0_x86_64/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install vllm.
ENV VLLM_ATTENTION_BACKEND="FLASH_ATTN"
RUN set -x \
&& pip install vllm==0.10.0 \
&& echo "end"

# install nixl.
RUN set -x \
&& pip install nixl \
&& echo "end"

# install mooncake.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/etcd/etcd-v3.6.4-linux-amd64.tar.gz -P /tmp \
&& tar -xzf /tmp/etcd-v3.6.4-linux-amd64.tar.gz -C /tmp \
&& cp /tmp/etcd-v3.6.4-linux-amd64/etcd /usr/bin \
&& cp /tmp/etcd-v3.6.4-linux-amd64/etcdctl /usr/bin \
&& cp /tmp/etcd-v3.6.4-linux-amd64/etcdutl /usr/bin \
&& echo "etcd --listen-client-urls http://127.0.0.1:2379 --advertise-client-urls http://127.0.0.1:2379 &" >> /boot.sh \
&& apt install -y libibverbs-dev \
&& apt install -y ibverbs-utils \
&& apt install -y rdma-core \
&& pip install mooncake-transfer-engine \
&& echo "mooncake_master --rpc_port 50001 --etcd_endpoints http://127.0.0.1:2379 --enable_ha=1 &" >> /boot.sh \
&& rm -rf /tmp/* \
&& echo "end"

# install lmcache.
RUN set -x \
&& pip install lmcache \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install 3pp.
RUN set -x \
&& pip install sentencepiece \
&& pip install autoawq \
&& pip install auto-gptq \
&& pip install llmcompressor \
&& pip install quart --ignore-installed \
&& pip install transformers==4.54.1 \
&& echo "end"

# clone vllm.
RUN set -x \
&& git clone -b v0.10.0 --recursive --depth=1 https://github.com/vllm-project/vllm.git /root/vllm \
&& echo "end"
