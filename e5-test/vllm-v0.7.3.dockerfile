FROM 10.150.9.98:80/devops_tools/vllm-v0.7.3:master
#-----------------------------------------------------------------------------------------------------------------------
# install driver.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nvidia/NVIDIA-Linux-x86_64-530.30.02.run -P /tmp \
&& bash /tmp/NVIDIA-Linux-x86_64-530.30.02.run --extract-only --target /tmp/umd \
&& cp /tmp/umd/libcuda.so.530.30.02 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.530.30.02 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& cp /tmp/umd/libnvidia-ml.so.530.30.02 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.530.30.02 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so \
&& cp /tmp/umd/nvidia-smi /usr/bin \
&& pip install nvidia-ml-py \
&& pip install nvitop \
&& ldconfig \
&& rm -rf /tmp/* \
&& echo "end"
