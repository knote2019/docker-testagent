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
&& tar -xf /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive.tar.xz -C /usr/local \
&& mv /usr/local/cudnn-linux-x86_64-8.9.5.30_cuda12-archive /usr/local/cudnn \
&& rm -rf /tmp/* \
&& echo "end"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cudnn/lib

#-----------------------------------------------------------------------------------------------------------------------
# install tvm.
RUN set -x \
&& apt install -y libtinfo-dev \
&& wget -nv http://10.113.3.1/corex/toolbox/tvm/apache-tvm-src-v0.17.0.tar.gz -P /tmp \
&& tar -xzf /tmp/apache-tvm-src-v0.17.0.tar.gz -C /tmp \
&& echo "install tvm cpp api" \
&& mkdir /tmp/apache-tvm-src-v0.17.0.rc0/build \
&& cd /tmp/apache-tvm-src-v0.17.0.rc0/build \
&& echo "set(USE_LLVM /usr/lib/llvm-16/bin/llvm-config)" > config.cmake \
&& echo "set(USE_CUDA ON)" >> config.cmake \
&& cmake .. \
&& make -j32 \
&& make install \
&& echo "install tvm python api" \
&& cd /tmp/apache-tvm-src-v0.17.0.rc0/python \
&& python gen_requirements.py \
&& pip install -r requirements/core.txt \
&& pip install . \
&& echo "install dmlc-core" \
&& mkdir /tmp/apache-tvm-src-v0.17.0.rc0/3rdparty/dmlc-core/build \
&& cd /tmp/apache-tvm-src-v0.17.0.rc0/3rdparty/dmlc-core/build \
&& cmake .. \
&& make -j32 \
&& make install \
&& echo "install dlpack" \
&& mkdir /tmp/apache-tvm-src-v0.17.0.rc0/3rdparty/dlpack/build \
&& cd /tmp/apache-tvm-src-v0.17.0.rc0/3rdparty/dlpack/build \
&& cmake .. \
&& make -j32 \
&& make install \
&& rm -rf /tmp/* \
&& echo "end"
