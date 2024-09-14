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
# install rust.
RUN set -x \
&& export RUSTUP_DIST_SERVER=http://mirrors.tuna.tsinghua.edu.cn/rustup \
&& export RUSTUP_UPDATE_ROOT=http://mirrors.tuna.tsinghua.edu.cn/rustup/rustup \
&& wget -nv http://10.113.3.1/corex/toolbox/rust/rustup.sh -P /tmp \
&& bash /tmp/rustup.sh -y \
&& echo "\
[source.crates-io]\n\
registry = 'https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git'\n\
[net]\n\
git-fetch-with-cli = true\n\
" > /root/.cargo/config.toml \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/root/.cargo/bin

# install protoc.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/protoc/protoc-21.12-linux-x86_64.zip -P /tmp \
&& unzip /tmp/protoc-21.12-linux-x86_64.zip -d /usr/local "bin/protoc" \
&& unzip /tmp/protoc-21.12-linux-x86_64.zip -d /usr/local 'include/*' \
&& rm -rf /tmp/* \
&& echo "end"

# install git.
RUN set -x \
&& apt install -y libcurl4-openssl-dev \
&& wget -nv http://10.113.3.1/corex/toolbox/git/git-2.46.0.tar.xz -P /tmp \
&& tar -xf /tmp/git-2.46.0.tar.xz -C /tmp \
&& cd /tmp/git-2.46.0 \
&& make configure \
&& ./configure --prefix=/usr --with-openssl \
&& make -j32 \
&& make install \
&& rm -rf /tmp/* \
&& echo "end"

# install tgi.
RUN set -x \
&& apt update \
&& apt install -y libssl-dev \
&& git config --global http.version HTTP/1.1 \
&& export https_proxy=http://192.168.100.200:3128 \
&& export no_proxy=pypi.tuna.tsinghua.edu.cn \
&& export TORCH_CUDA_ARCH_LIST="8.0" \
&& git clone -b v2.1.1 https://github.com/huggingface/text-generation-inference.git \
&& cd text-generation-inference \
&& make install \
&& rm -rf /tmp/* \
&& echo "end"
