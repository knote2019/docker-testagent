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
&& echo "install cuda" \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.4.1_550.54.15_linux.run -P /tmp \
&& bash /tmp/cuda_12.4.1_550.54.15_linux.run --toolkit --silent \
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
&& wget -nv http://10.113.3.1/corex/toolbox/cudnn/cudnn-linux-x86_64-8.9.5.30_cuda12-archive.tar.xz -P /tmp \
&& tar -xf /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive.tar.xz -C /tmp \
&& cp -r /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive/include/* /usr/local/cuda/include \
&& cp -r /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

# install nccl.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nccl/nccl_2.21.5-1+cuda12.4_x86_64.txz -P /tmp \
&& tar -xf /tmp/nccl_2.21.5-1+cuda12.4_x86_64.txz -C /tmp \
&& cp -r /tmp/nccl_2.21.5-1+cuda12.4_x86_64/include/* /usr/local/cuda/include \
&& cp -r /tmp/nccl_2.21.5-1+cuda12.4_x86_64/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install pytorch.
RUN set -x \
&& pip install http://10.113.3.1/corex/toolbox/pytorch/torch-2.3.1%2Bcpu-cp310-cp310-linux_x86_64.whl \
&& echo "end"

# install tensorrt.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/tensorrt/TensorRT-10.1.0.27.Linux.x86_64-gnu.cuda-12.4.tar.gz -P /tmp \
&& tar -xzf /tmp/TensorRT-10.1.0.27.Linux.x86_64-gnu.cuda-12.4.tar.gz -C /usr/local \
&& mv /usr/local/TensorRT-10.1.0.27 /usr/local/tensorrt \
&& mv /usr/local/tensorrt/lib/libnvinfer_builder_resource.so.10.1.0 /usr/lib/x86_64-linux-gnu \
&& pip install /usr/local/tensorrt/python/tensorrt-10.1.0-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_dispatch-10.1.0-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_lean-10.1.0-cp310-none-linux_x86_64.whl \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/tensorrt/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tensorrt/lib

# install tensorrt-llm.
RUN set -x \
&& pip install accelerate \
&& pip install http://10.113.3.1/corex/toolbox/tensorrt-llm/tensorrt_llm-0.11.0-cp310-cp310-linux_x86_64.whl \
&& echo "end"

# # clone tensorrt-llm repo.
# RUN set -x \
# && export https_proxy=http://192.168.100.200:3128 \
# && git clone -b v0.11.0 --recursive https://github.com/NVIDIA/TensorRT-LLM.git /root/TensorRT-LLM \
# && echo "end"
