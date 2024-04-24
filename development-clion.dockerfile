FROM 10.150.9.98:80/devops_tools/ubuntu22.04-kasmvnc-amd64:master
#-----------------------------------------------------------------------------------------------------------------------
# install chrome.
RUN set -x \
&& apt update \
&& apt install ttf-wqy-zenhei \
&& wget -nv http://10.113.3.1/corex/toolbox/chrome/google-chrome-stable_current_amd64.deb -P /tmp \
&& apt install -y -f /tmp/google-chrome-stable_current_amd64.deb \
&& sed -i 's/google-chrome-stable/google-chrome-stable --no-sandbox/' /usr/share/applications/google-chrome.desktop \
&& apt clean all \
&& rm -rf /tmp/* \
&& echo "end"
#-----------------------------------------------------------------------------------------------------------------------
# install clion.
RUN set -x \
&& apt update \
&& apt install -y clang-format \
&& wget -nv http://10.113.3.1/corex/toolbox/ide/CLion-2021.3.4.tar.gz -P /tmp \
&& tar -xzf /tmp/CLion-2021.3.4.tar.gz -C /opt \
&& echo "\
[Desktop Entry]\n\
Name=CLion\n\
Comment=CLion\n\
Exec=/opt/clion-2021.3.4/bin/clion.sh\n\
Icon=/opt/clion-2021.3.4/bin/clion.png\n\
Terminal=false\n\
Type=Application\n\
Categories=Development\n\
" > /usr/share/applications/clion.desktop \
&& echo "fs.inotify.max_user_watches = 500000" > /etc/sysctl.d/60-jetbrains.conf \
&& sysctl -p \
&& rm -rf /tmp/* \
&& echo "end"
