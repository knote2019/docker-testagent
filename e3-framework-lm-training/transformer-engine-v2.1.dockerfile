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
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.1.1_530.30.02_linux.run -P /tmp \
&& bash /tmp/cuda_12.1.1_530.30.02_linux.run --toolkit --silent \
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
&& wget -nv http://10.113.3.1/corex/toolbox/cudnn/cudnn-linux-x86_64-9.1.0.70_cuda12-archive.tar.xz -P /tmp \
&& tar -xf /tmp/cudnn-linux-x86_64-9.1.0.70_cuda12-archive.tar.xz -C /tmp \
&& cp -r /tmp/cudnn-linux-x86_64-9.1.0.70_cuda12-archive/include/* /usr/local/cuda/include \
&& cp -r /tmp/cudnn-linux-x86_64-9.1.0.70_cuda12-archive/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

# install nccl.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nccl/nccl_2.18.3-1+cuda12.1_x86_64.txz -P /tmp \
&& tar -xf /tmp/nccl_2.18.3-1+cuda12.1_x86_64.txz -C /tmp \
&& cp -r /tmp/nccl_2.18.3-1+cuda12.1_x86_64/include/* /usr/local/cuda/include \
&& cp -r /tmp/nccl_2.18.3-1+cuda12.1_x86_64/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install torch.
ENV TORCH_CUDA_ARCH_LIST="8.0"
RUN set -x \
&& pip install http://10.113.3.1/corex/toolbox/pytorch/torch-2.4.1+cu121-cp310-cp310-linux_x86_64.whl \
&& echo "end"

# install flash-attn.
RUN set -x \
&& pip install setuptools>=61 \
&& git clone -b master --recursive --depth=1 http://bitbucket.iluvatar.ai:7990/scm/swte/flash-attention-v2.6.3.git /usr/local/flash-attention \
&& pip install /usr/local/flash-attention --no-build-isolation --verbose \
&& echo "end"

# install transformer-engine.
ENV NVTE_FRAMEWORK="pytorch"
RUN set -x \
&& git clone -b master --recursive --depth=1 http://bitbucket.iluvatar.ai:7990/scm/swte/TransformerEngine-v2.1.git /usr/local/TransformerEngine \
&& pip install /usr/local/TransformerEngine --no-build-isolation --verbose \
&& echo "end"
