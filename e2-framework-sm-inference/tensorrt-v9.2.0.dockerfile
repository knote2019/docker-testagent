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
&& apt update \
&& apt install -y libxml2 \
&& sed -i '/deprecated/s/^\(.*\)$/#\1/g' /usr/bin/which \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.2.0_535.54.03_linux.run -P /tmp \
&& bash /tmp/cuda_12.2.0_535.54.03_linux.run --toolkit --silent \
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

#-----------------------------------------------------------------------------------------------------------------------
# install tensorrt.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/tensorrt/tensorrt-9.2.0.5.linux.x86_64-gnu.cuda-12.2.tar.gz -P /tmp \
&& tar -xzf /tmp/tensorrt-9.2.0.5.linux.x86_64-gnu.cuda-12.2.tar.gz -C /usr/local \
&& mv /usr/local/TensorRT-9.2.0.5 /usr/local/tensorrt \
&& mv /usr/local/tensorrt/lib/libnvinfer_builder_resource.so.9.2.0 /usr/lib/x86_64-linux-gnu \
&& pip install /usr/local/tensorrt/python/tensorrt-9.2.0.post12.dev5-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_dispatch-9.2.0.post12.dev5-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_lean-9.2.0.post12.dev5-cp310-none-linux_x86_64.whl \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/tensorrt/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tensorrt/lib
