FROM 10.150.9.98:80/devops_tools/core-testagent:master
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
&& rm -rf /tmp/* \
&& echo "end"

# install cuda.
RUN set -x \
&& apt update \
&& apt install -y libxml2 \
&& sed -i '/deprecated/s/^\(.*\)$/#\1/g' /usr/bin/which \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.1.1_530.30.02_linux.run -P /tmp \
&& bash /tmp/cuda_12.1.1_530.30.02_linux.run --toolkit --silent \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-compute.desktop \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-systems.desktop \
&& sed -i "s,host-linux-x64/nsight-sys,host-linux-x64/nsys-ui,g" /usr/share/applications/nsight-systems.desktop  \
&& rm -f /usr/share/applications/nsight.desktop \
&& rm -f /usr/share/applications/nvvp.desktop \
&& rm -rf /tmp/* \
&& echo "end"
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
# install pytorch.
RUN set -x \
&& pip install http://10.113.3.1/corex/toolbox/pytorch/torch-2.4.0+cu121-cp310-cp310-linux_x86_64.whl \
&& echo "end"

# install flashinfer.
RUN set -x \
&& git clone -b v0.1.5 --recursive https://github.com/flashinfer-ai/flashinfer.git /usr/local/flashinfer \
&& pip install -e /usr/local/flashinfer/python \
&& echo "end"

# install sglang.
RUN set -x \
&& git clone -b v0.2.12 https://github.com/sgl-project/sglang.git /usr/local/sglang \
&& cd /usr/local/sglang \
&& pip install -e "python[all]" \
&& echo "end"
