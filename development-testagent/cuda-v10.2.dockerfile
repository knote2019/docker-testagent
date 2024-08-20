FROM 10.150.9.98:80/devops_tools/core-testagent:master
#-----------------------------------------------------------------------------------------------------------------------
# install driver.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/NVIDIA-Linux-x86_64-440.33.01.run -P /tmp \
&& bash /tmp/NVIDIA-Linux-x86_64-440.33.01.run --extract-only --target /tmp/umd \
&& cp /tmp/umd/libcuda.so.440.33.01 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.440.33.01 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& cp /tmp/umd/libnvidia-ml.so.440.33.01 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.440.33.01 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
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
&& wget -nv http://10.113.3.1/corex/toolbox/cuda10.2/cuda_10.2.89_440.33.01_linux.run -P /tmp \
&& bash /tmp/cuda_10.2.89_440.33.01_linux.run --toolkit --silent \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda10.2/cudnn-10.2-linux-x64-v7.6.5.32.tgz -P /tmp \
&& tar -xf /tmp/cudnn-10.2-linux-x64-v7.6.5.32.tgz -C /usr/local \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
