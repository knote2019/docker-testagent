FROM 10.150.9.98:80/devops_tools/ubuntu22.04-ide-x86_64:master
#-----------------------------------------------------------------------------------------------------------------------
# configure git.
RUN set -x \
&& git config --global credential.helper store \
&& git config --global user.name kasmvnc \
&& git config --global user.email kasmvnc@iluvatar.com \
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

# install ninja.
RUN set -x \
&& apt install -y ninja-build \
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

# install vscode.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/ide/code_1.88.1-1712771838_amd64.deb -P /tmp \
&& dpkg -i /tmp/code_1.88.1-1712771838_amd64.deb \
&& sed -i 's$/usr/share/code/code$/usr/share/code/code --no-sandbox --user-data-dir$' /usr/share/applications/code.desktop \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install driver.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/NVIDIA-Linux-x86_64-555.42.02.run -P /tmp \
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

# install openmpi.
RUN set -x \
&& apt install -y openmpi-bin \
&& apt install -y libopenmpi-dev \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install tensorrt-llm.
RUN set -x \
&& export https_proxy=http://192.168.100.200:3128 \
&& pip install accelerate \
&& pip install tensorrt-llm==0.11.0 --index-url https://pypi.nvidia.com \
&& echo "end"
