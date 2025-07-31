FROM nvcr.io/nvidia/tensorrt-llm/release:0.20.0

# set entrypoint.
RUN set -x \
&& echo > /boot.sh \
&& chmod +x /boot.sh \
&& echo '#!/usr/bin/env bash' >/usr/bin/entrypoint \
&& echo 'bash /boot.sh' >>/usr/bin/entrypoint \
&& echo 'cat' >>/usr/bin/entrypoint \
&& chmod +x /usr/bin/entrypoint
ENV DEBIAN_FRONTEND=noninteractive
ENTRYPOINT ["/usr/bin/entrypoint"]
WORKDIR /root

#-----------------------------------------------------------------------------------------------------------------------
# set repo.
RUN set -x \
# && rm -f /etc/apt/sources.list.d/* \
&& echo "\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse\n\
" > /etc/apt/sources.list \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install common.
RUN set -x \
&& apt update \
&& apt install -y wget \
&& apt install -y tar \
&& apt install -y zip \
&& apt install -y git \
&& apt install -y vim \
&& apt install -y g++ \
&& apt install -y make \
&& apt install -y pkg-config \
&& apt clean all \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install gui.
RUN set -x \
&& apt update \
&& apt install -y xfce4 \
&& apt install -y xfce4-goodies \
&& apt purge -y xfce4-power-manager-plugins \
&& apt purge -y gnome-terminal \
&& wget -nv http://10.113.3.1/corex/toolbox/kasmvncserver/kasmvncserver_noble_1.3.2_amd64.deb -P /tmp \
&& apt install -y /tmp/kasmvncserver_noble_1.3.2_amd64.deb \
&& echo 'cloud:$5$kasm$DAH8fimyo3/UVSYcM534anM9sdDKXe1qfQmzNtiUBw/:ow' > /root/.kasmpasswd \
&& rm -f /etc/xdg/autostart/xfce-polkit.desktop \
&& mv /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml \
&& echo "rm -f /tmp/.X1-lock; vncserver -kill :1; vncserver :1 -select-de xfce -geometry 1280x720 -depth 24 -websocketPort 6901 \
-FrameRate=24 -interface 0.0.0.0 -BlacklistThreshold=0 -FreeKeyMappings -PreferBandwidth \
-DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0" >> /boot.sh \
&& apt install -y dbus-x11 \
&& rm -rf /tmp/* \
&& echo "end"
EXPOSE 6901

#-----------------------------------------------------------------------------------------------------------------------
# install chrome.
RUN set -x \
&& apt update \
&& apt install ttf-wqy-zenhei \
&& wget -nv http://10.113.3.1/corex/toolbox/chrome/google-chrome-stable_current_amd64.deb -P /tmp \
&& apt install -y -f /tmp/google-chrome-stable_current_amd64.deb \
&& cat /usr/share/applications/google-chrome.desktop > /usr/share/applications/xfce4-web-browser.desktop \
&& sed -i 's@exec -a "$0" "$HERE/chrome" "$\@"@exec -a "$0" "/opt/google/chrome/google-chrome" "--no-sandbox" "$\@"@g' /usr/bin/x-www-browser \
&& sed -i 's@exec -a "$0" "$HERE/chrome" "$\@"@exec -a "$0" "/opt/google/chrome/google-chrome" "--no-sandbox" "$\@"@g' /usr/bin/google-chrome \
&& sed -i 's@exec -a "$0" "$HERE/chrome" "$\@"@exec -a "$0" "/opt/google/chrome/google-chrome" "--no-sandbox" "$\@"@g' /usr/bin/google-chrome-stable \
&& apt clean all \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# configure sysctl.
RUN set -x \
&& echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.conf \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# configure graphviz.
RUN set -x \
&& apt install -y graphviz \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install pycharm.
RUN set -x \
&& apt update \
&& pip install pytest \
&& wget -nv http://10.113.3.1/corex/toolbox/ide/pycharm-community-2022.3.3.tar.gz -P /tmp \
&& tar -xzf /tmp/pycharm-community-2022.3.3.tar.gz -C /opt \
&& echo -e "\
[Desktop Entry]\n\
Name=Pycharm\n\
Comment=Pycharm\n\
Exec=/opt/pycharm-community-2022.3.3/bin/pycharm.sh\n\
Icon=/opt/pycharm-community-2022.3.3/bin/pycharm.png\n\
Terminal=false\n\
Type=Application\n\
Categories=Development\n\
" > /usr/share/applications/pycharm.desktop \
# && python /opt/pycharm-community-2022.3.3/plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace \
&& wget -nv http://10.113.3.1/corex/toolbox/ide/pytest-tool.tar.gz -P /tmp \
&& tar -xzf /tmp/pytest-tool.tar.gz -C /root \
&& rm -rf /tmp/* \
&& echo "end"

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
