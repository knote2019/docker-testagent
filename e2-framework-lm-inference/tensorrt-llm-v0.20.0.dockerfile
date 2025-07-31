FROM 10.150.9.98:80/devops_tools/ubuntu22.04-testagent:master
#-----------------------------------------------------------------------------------------------------------------------
# install driver.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nvidia/NVIDIA-Linux-x86_64-575.57.08.run -P /tmp \
&& bash /tmp/NVIDIA-Linux-x86_64-575.57.08.run --extract-only --target /tmp/umd \
&& cp /tmp/umd/libcuda.so.575.57.08 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& cp /tmp/umd/libnvidia-ml.so.575.57.08 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so \
&& cp /tmp/umd/nvidia-smi /usr/bin \
&& pip install nvidia-ml-py \
&& pip install nvitop \
&& ldconfig \
&& rm -rf /tmp/* \
&& echo "end"

# install cuda.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.9.0_575.51.03_linux.run -P /tmp \
&& bash /tmp/cuda_12.9.0_575.51.03_linux.run --toolkit --silent \
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
&& wget -nv http://10.113.3.1/corex/toolbox/nccl/nccl_2.22.3-1+cuda12.5_x86_64.txz -P /tmp \
&& tar -xf /tmp/nccl_2.22.3-1+cuda12.5_x86_64.txz -C /tmp \
&& cp -r /tmp/nccl_2.22.3-1+cuda12.5_x86_64/include/* /usr/local/cuda/include \
&& cp -r /tmp/nccl_2.22.3-1+cuda12.5_x86_64/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install tensorrt.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/tensorrt/TensorRT-10.10.0.31.Linux.x86_64-gnu.cuda-12.9.tar.gz -P /tmp \
&& tar -xzf /tmp/TensorRT-10.10.0.31.Linux.x86_64-gnu.cuda-12.9.tar.gz -C /usr/local \
&& mv /usr/local/TensorRT-10.10.0.31 /usr/local/tensorrt \
&& mv /usr/local/tensorrt/lib/libnvinfer_builder_resource.so.10.10.0 /usr/lib/x86_64-linux-gnu \
&& pip install /usr/local/tensorrt/python/tensorrt-10.10.0.31-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_dispatch-10.10.0.31-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_lean-10.10.0.31-cp310-none-linux_x86_64.whl \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/tensorrt/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tensorrt/lib

# install tensorrt-llm.
RUN set -x \
&& pip install accelerate \
&& pip install http://10.113.3.1/corex/toolbox/tensorrt-llm/tensorrt_llm-0.20.0-cp310-cp310-linux_x86_64.whl \
&& echo "end"
