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
# install pycharm.
RUN set -x \
&& apt update \
&& pip install yapf \
&& wget -nv http://10.113.3.1/corex/toolbox/ide/pycharm-community-2024.1.1.tar.gz -P /tmp \
&& tar -xzf /tmp/pycharm-community-2024.1.1.tar.gz -C /opt \
&& echo "\
[Desktop Entry]\n\
Name=Pycharm\n\
Comment=Pycharm\n\
Exec=/opt/pycharm-community-2024.1.1/bin/pycharm.sh\n\
Icon=/opt/pycharm-community-2024.1.1/bin/pycharm.png\n\
Terminal=false\n\
Type=Application\n\
Categories=Development\n\
" > /usr/share/applications/pycharm.desktop \
&& rm -rf /tmp/* \
&& echo "end"
