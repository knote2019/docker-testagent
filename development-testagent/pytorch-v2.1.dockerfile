FROM 10.150.9.98:80/devops_tools/ubuntu22.04-ide-x86_64:master
#-----------------------------------------------------------------------------------------------------------------------
# configure git.
RUN set -x \
&& git config --global credential.helper store \
&& git config --global user.name minghong.kang \
&& git config --global user.email minghong.kang@iluvatar.com \
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

# install ncurses.
RUN set -x \
&& apt install -y libncurses5-dev \
&& apt install -y libncursesw5-dev \
&& echo "end"

# add more xcb libs for GUI apps.
RUN set -x \
&& apt install -y libxkbcommon-x11-0 \
&& apt install -y libxcb-icccm4 \
&& apt install -y libxcb-image0 \
&& apt install -y libxcb-keysyms1 \
&& apt install -y libxcb-render-util0 \
&& apt install -y libxcb-xinerama0 \
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
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/NVIDIA-Linux-x86_64-530.30.02.run -P /tmp \
&& bash /tmp/NVIDIA-Linux-x86_64-530.30.02.run --extract-only --target /tmp/umd \
&& cp /tmp/umd/libcuda.so.530.30.02 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.530.30.02 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& cp /tmp/umd/libnvidia-ml.so.530.30.02 /usr/lib/x86_64-linux-gnu \
&& ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.530.30.02 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
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
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-compute.desktop \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-systems.desktop \
&& sed -i "s,host-linux-x64/nsight-sys,host-linux-x64/nsys-ui,g" /usr/share/applications/nsight-systems.desktop  \
&& rm -f /usr/share/applications/nsight.desktop \
&& rm -f /usr/share/applications/nvvp.desktop \
&& rm -rf /tmp/* \
&& echo "end"
ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

# install clang (cuda compiler)
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

# install nvitop.
RUN set -x \
&& pip install nvidia-ml-py \
&& pip install nvitop \
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
&& apt install -y libgtk2.0-dev \
&& apt install -y gtk2-engines-pixbuf \
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

# install transformer engine (need install from git clone code).
RUN set -x \
&& pip install packaging \
&& pip install flash-attn==2.4.2 \
&& git clone -b v1.7 --recursive https://github.com/NVIDIA/TransformerEngine.git /tmp/TransformerEngine \
&& cd /tmp/TransformerEngine \
&& export NVTE_FRAMEWORK=pytorch \
&& pip install . \
&& rm -rf /tmp/* \
&& echo "end"

# install apex.
RUN set -x \
&& git clone https://github.com/NVIDIA/apex \
&& cd apex \
&& git checkout 6943fd26e04c59327de32592cf5af68be8f5c44e \
&& pip install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" . \
&& rm -rf /tmp/* \
&& echo "end"

# install transformers.
RUN set -x \
&& pip install transformers==4.33.1 \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install python-3pp.
RUN set -x \
&& pip install PyQt5 \
&& pip install fire \
&& pip install numpy==1.26.4 \
&& pip install scipy \
&& pip install opencv_python \
&& pip install onnx \
&& pip install fairscale \
&& pip install sentencepiece \
&& echo "end"
