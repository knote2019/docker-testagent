FROM 10.150.9.98:80/devops-nvidia/ubuntu22.04-dev-x86_64:master
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
&& apt install -y curl \
&& apt install -y gdb \
&& apt install -y gdbserver \
&& echo "end"

# install clang.
RUN set -x \
&& echo "deb http://mirrors.tuna.tsinghua.edu.cn/llvm-apt/jammy/ llvm-toolchain-jammy-18 main" \
> /etc/apt/sources.list.d/clang.list \
&& wget -O - http://10.113.3.1/corex/toolbox/clang/llvm-snapshot.gpg.key | apt-key add - \
&& apt update \
&& apt install -y clang-18 \
&& apt install -y lldb-18 \
&& apt install -y lld-18 \
&& ln -sf /usr/bin/clang-18 /usr/bin/clang \
&& ln -sf /usr/bin/clang++-18 /usr/bin/clang++ \
&& ln -sf /usr/bin/lldb-18 /usr/bin/lldb \
&& echo "end"

# install cmake.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cmake/cmake-3.31.6-linux-x86_64.sh -P /tmp \
&& bash /tmp/cmake-3.31.6-linux-x86_64.sh --skip-license --include-subdir --prefix=/usr/local \
&& ln -sf /usr/local/cmake-3.31.6-linux-x86_64/bin/cmake /usr/bin/cmake \
&& rm -rf /tmp/* \
&& echo "end"

# install ninja.
RUN set -x \
&& apt install -y ninja-build \
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

#-----------------------------------------------------------------------------------------------------------------------
# install ncurses.
RUN set -x \
&& apt update \
&& apt install -y libncurses5-dev \
&& apt install -y libncursesw5-dev \
&& echo "end"

# install xcb: https://launchpad.net/ubuntu/+source/libxcb.
RUN set -x \
&& apt update \
&& apt install -y libxkbcommon-x11-0 \
&& apt install -y libxcb-cursor0 \
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
&& apt update \
&& apt install -y language-pack-zh-hans \
&& apt install -y language-pack-zh-hant \
&& echo "end"

# configure no_proxy.
ENV no_proxy=pypi.tuna.tsinghua.edu.cn

# install 3pp.
RUN set -x \
&& apt update \
&& apt install -y libssl-dev \
&& apt install -y libxml2 \
&& apt install -y graphviz \
&& apt install -y python3-tk \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install python-3pp.
RUN set -x \
&& pip install packaging \
&& pip install setuptools \
&& pip install setuptools_scm \
&& pip install typing_extensions \
&& pip install pybind11 \
&& pip install pytest \
&& pip install allure-pytest \
&& pip install numpy \
&& pip install matplotlib \
&& echo "end"

# configure MAX_JOBS.
ENV MAX_JOBS=32

# fix which cmd.
RUN set -x \
&& sed -i '/deprecated/s/^\(.*\)$/#\1/g' /usr/bin/which \
&& echo "end"

# configure known_hosts.
RUN set -x \
&& ssh-keyscan -H github.com >> ~/.ssh/known_hosts \
&& echo "end"

# configure bashrc.
RUN set -x \
&& echo "alias ll='ls --color -alF'">/root/.bashrc \
&& echo "export PS1='\[\033[01;37m\][\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;34m\]\h\[\033[01;36m\] \w\[\033[01;37m\]]\[\033[01;35m\]\$ \[\033[0m\]'">>/root/.bashrc \
&& echo "export \$(cat /proc/1/environ | tr \"\\\0\" \"\\\t\" | xargs)">>/root/.bashrc \
&& echo "end"
