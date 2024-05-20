FROM 10.150.9.98:80/devops_tools/development-pycharm:master
#-----------------------------------------------------------------------------------------------------------------------
# configure git.
RUN set -x \
&& git config --global user.name kasmvnc \
&& git config --global user.email kasmvnc@kasmvnc.com \
&& echo "end"

# install tool.
RUN set -x \
&& apt update \
&& apt install -y rsync \
&& apt install -y pciutils \
&& apt install -y kmod \
&& apt install -y gnupg \
&& apt install -y iproute2 \
&& apt install -y gdb \
&& apt install -y gdbserver \
&& apt clean all \
&& echo "end"

# set timezone.
RUN set -x \
&& apt update \
&& apt install -y tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "end"

# install language.
RUN set -x \
&& apt install -y language-pack-zh-hans \
&& apt install -y language-pack-zh-hant \
&& echo "end"

# configure bashrc.
RUN set -x \
&& echo "alias ll='ls --color -alF'">/root/.bashrc \
&& echo "export PS1='\[\033[01;37m\][\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;34m\]\h\[\033[01;36m\] \w\[\033[01;37m\]]\[\033[01;35m\]\$ \[\033[0m\]'">>/root/.bashrc \
&& echo "export \$(cat /proc/1/environ | tr \"\\\0\" \"\\\t\" | xargs)">>/root/.bashrc \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install umd.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/NVIDIA-Linux-x86_64-535.54.03.run -P /tmp \
&& bash /tmp/NVIDIA-Linux-x86_64-535.54.03.run --extract-only --target /tmp/umd \
&& cp /tmp/umd/libcuda.so.535.54.03 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.535.54.03 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& cp /tmp/umd/libnvidia-ml.so.535.54.03 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.535.54.03 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so \
&& cp /tmp/umd/nvidia-smi /usr/bin \
&& rm -rf /tmp/* \
&& echo "end"

# install cuda.
RUN set -x \
&& apt update \
&& apt install -y libxml2 \
&& sed -i '/deprecated/s/^\(.*\)$/#\1/g' /usr/bin/which \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.1.1_530.30.02_linux.run -P /tmp \
&& bash /tmp/cuda_12.1.1_530.30.02_linux.run --toolkit --silent \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cudnn-linux-x86_64-8.9.6.50_cuda12-archive.tar.xz -P /tmp \
&& tar -xf /tmp/cudnn-linux-x86_64-8.9.6.50_cuda12-archive.tar.xz -C /tmp \
&& cp -r /tmp/cudnn-linux-x86_64-8.9.6.50_cuda12-archive/include/* /usr/local/cuda/include \
&& cp -r /tmp/cudnn-linux-x86_64-8.9.6.50_cuda12-archive/lib/* /usr/local/cuda/lib64 \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/nccl_2.18.3-1+cuda12.1_x86_64.txz -P /tmp \
&& tar -xf /tmp/nccl_2.18.3-1+cuda12.1_x86_64.txz -C /tmp \
&& cp -r /tmp/nccl_2.18.3-1+cuda12.1_x86_64/include/* /usr/local/cuda/include \
&& cp -r /tmp/nccl_2.18.3-1+cuda12.1_x86_64/lib/* /usr/local/cuda/lib64 \
&& ldconfig \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

# install nvtop.
RUN set -x \
&& apt install -y libncurses5-dev \
&& apt install -y libncursesw5-dev \
&& apt install -y libudev-dev \
&& apt install -y libdrm-dev \
&& wget -nv http://10.113.3.1/corex/toolbox/nvtop/nvtop-3.1.0.tar.gz -P /tmp \
&& tar -xzf /tmp/nvtop-3.1.0.tar.gz -C /tmp \
&& mkdir /tmp/nvtop-3.1.0/build \
&& cd /tmp/nvtop-3.1.0/build \
&& cmake .. \
&& make \
&& mv src/nvtop /usr/bin/ixtop \
&& rm -rf /tmp/* \
&& echo "end"

# install clang.
RUN set -x \
&& echo "deb http://mirrors.tuna.tsinghua.edu.cn/llvm-apt/jammy/ llvm-toolchain-jammy-16 main" \
> /etc/apt/sources.list.d/clang.list \
&& wget -O - http://10.113.3.1/corex/toolbox/clang/llvm-snapshot.gpg.key | apt-key add - \
&& apt update \
&& apt install -y clang-16 \
&& apt install -y lldb-16 \
&& apt install -y lld-16 \
&& ln -sf /usr/bin/clang-16 /usr/bin/clang \
&& ln -sf /usr/bin/clang++-16 /usr/bin/clang++ \
&& ln -sf /usr/bin/lldb-16 /usr/bin/lldb \
&& apt clean all \
&& echo "end"

# install cmake.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cmake/cmake-3.25.2-linux-x86_64.sh -P /tmp \
&& bash /tmp/cmake-3.25.2-linux-x86_64.sh --skip-license --include-subdir --prefix=/usr/local \
&& ln -sf /usr/local/cmake-3.25.2-linux-x86_64/bin/cmake /usr/bin/cmake \
&& rm -rf /tmp/* \
&& echo "end"

# install ffmpeg.
RUN set -x \
&& apt install -y yasm \
&& apt install -y libx264-dev \
&& apt install -y libx265-dev \
&& apt install -y libsdl2-dev \
&& wget -nv http://10.113.3.1/corex/toolbox/ffmpeg/n7.0.tar.gz -P /tmp \
&& tar -xzf /tmp/n7.0.tar.gz -C /tmp \
&& cd /tmp/FFmpeg-n7.0 \
&& ./configure --prefix=/usr/local/ffmpeg --enable-gpl --enable-libx264 --enable-libx265 --enable-ffplay --enable-ffprobe --enable-shared \
&& make -j32 \
&& make install \
&& echo "/usr/local/ffmpeg/lib" > /etc/ld.so.conf.d/ffmpeg.conf \
&& ldconfig \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/ffmpeg/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/ffmpeg/lib

# install opencv.
RUN set -x \
&& export https_proxy=http://192.168.100.200:3128 \
&& wget -nv http://10.113.3.1/corex/toolbox/opencv/4.8.0.tar.gz -P /tmp \
&& tar -xzf /tmp/4.8.0.tar.gz -C /tmp \
&& mkdir /tmp/opencv-4.8.0/build \
&& cd /tmp/opencv-4.8.0/build \
&& cmake -D CMAKE_INSTALL_PREFIX=/tmp/opencv -DCMAKE_CXX_FLAGS='-D_GLIBCXX_USE_CXX11_ABI=0' .. \
&& make -j32 \
&& make install \
&& cp -r /tmp/opencv/include/opencv4/* /usr/local/include \
&& cp -r /tmp/opencv/lib/* /usr/local/lib \
&& rm -rf /tmp/* \
&& echo "end"

# install openmpi.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/openmpi/openmpi-5.0.2.tar.gz -P /tmp \
&& tar -xzf /tmp/openmpi-5.0.2.tar.gz -C /tmp \
&& cd /tmp/openmpi-5.0.2 \
&& ./configure \
&& make -j32 \
&& make install \
&& ldconfig \
&& rm -rf /tmp/* \
&& echo "end"

# install torch.
RUN set -x \
&& pip install http://10.113.3.1/corex/toolbox/pytorch/torch-2.1.1+cu121-cp310-cp310-linux_x86_64.whl \
&& pip install http://10.113.3.1/corex/toolbox/pytorch/torchvision-0.16.1+cu121-cp310-cp310-linux_x86_64.whl \
&& echo "end"

# install transformer engine.
RUN set -x \
&& pip install packaging \
&& pip install flash-attn==2.4.2 \
&& git clone --branch release_v1.6 --recursive https://github.com/NVIDIA/TransformerEngine.git \
&& cd TransformerEngine \
&& export NVTE_FRAMEWORK=pytorch \
&& pip install . \
&& rm -rf /tmp/* \
&& echo "end"

# install transformers.
RUN set -x \
&& pip install transformers==4.33.1 \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install python-3pp.
RUN set -x \
&& pip install numpy \
&& pip install scipy \
&& pip install opencv_python \
&& pip install onnx \
&& echo "end"

# install torch-examples.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/pytorch-models/torch-examples-main.zip -P /tmp \
&& unzip -q /tmp/torch-examples-main.zip -d /root \
&& rm -rf /tmp/* \
&& echo "end"

# install ultralytics.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/pytorch-models/yolov5-v7.0.tar.gz -P /tmp \
&& tar -xzf /tmp/yolov5-v7.0.tar.gz -C /root \
&& pip install ultralytics \
&& rm -rf /tmp/* \
&& echo "end"

# install llama2.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/llm-models/llama-v2.tar.gz -P /tmp \
&& tar -xzf /tmp/llama-v2.tar.gz -C /root \
&& rm -rf /tmp/* \
&& echo "end"
