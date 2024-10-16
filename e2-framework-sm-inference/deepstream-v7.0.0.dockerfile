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
&& wget -nv http://10.113.3.1/corex/toolbox/cudnn/cudnn-linux-x86_64-8.8.1.3_cuda12-archive.tar.xz -P /tmp \
&& tar -xf /tmp/cudnn-linux-x86_64-8.8.1.3_cuda12-archive.tar.xz -C /tmp \
&& cp -r /tmp/cudnn-linux-x86_64-8.8.1.3_cuda12-archive/include/* /usr/local/cuda/include \
&& cp -r /tmp/cudnn-linux-x86_64-8.8.1.3_cuda12-archive/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install tensorrt.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/tensorrt/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz -P /tmp \
&& tar -xzf /tmp/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz -C /usr/local \
&& mv /usr/local/TensorRT-8.6.1.6 /usr/local/tensorrt \
&& mv /usr/local/tensorrt/lib/libnvinfer_builder_resource.so.8.6.1 /usr/lib/x86_64-linux-gnu \
&& pip install /usr/local/tensorrt/python/tensorrt-8.6.1.post12.dev5-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_dispatch-8.6.1.post12.dev5-cp310-none-linux_x86_64.whl \
&& pip install /usr/local/tensorrt/python/tensorrt_lean-8.6.1.post12.dev5-cp310-none-linux_x86_64.whl \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/tensorrt/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tensorrt/lib

# install gstreamer.
RUN set -x \
&& apt-get install -y libgstreamer1.0-0 \
&& apt-get install -y libgstreamer1.0-dev \
&& apt-get install -y gstreamer1.0-plugins-base \
&& apt-get install -y gstreamer1.0-plugins-base-apps \
&& apt-get install -y gstreamer1.0-plugins-good \
&& apt-get install -y gstreamer1.0-plugins-bad \
&& apt-get install -y gstreamer1.0-plugins-ugly \
&& apt-get install -y gstreamer1.0-libav \
&& apt-get install -y gstreamer1.0-tools \
&& apt-get install -y gstreamer1.0-x \
&& apt-get install -y gstreamer1.0-alsa \
&& apt-get install -y gstreamer1.0-gl \
&& apt-get install -y gstreamer1.0-gtk3 \
&& apt-get install -y gstreamer1.0-qt5 \
&& apt-get install -y gstreamer1.0-pulseaudio \
&& apt-get install -y libgstrtspserver-1.0-0 \
&& apt-get install -y libjansson4 \
&& echo "end"

# install deepstream.
RUN set -x \
&& apt-get install -y libyaml-cpp-dev \
&& wget -nv http://10.150.9.95/corex/deepstream/deepstream_sdk_v7.0.0_x86_64.tbz2 -P /tmp \
&& tar -xvf /tmp/deepstream_sdk_v7.0.0_x86_64.tbz2 -C / \
&& bash /opt/nvidia/deepstream/deepstream/install.sh \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/opt/nvidia/deepstream/deepstream/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/nvidia/deepstream/deepstream/lib
