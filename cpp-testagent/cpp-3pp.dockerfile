FROM 10.150.9.98:80/devops_tools/core-testagent:master
#-----------------------------------------------------------------------------------------------------------------------
# install libgit2.
RUN set -x \
&& apt update \
&& apt install -y libssl-dev \
&& git clone -b v1.8.4 https://github.com/libgit2/libgit2.git /tmp/libgit2 \
&& mkdir /tmp/libgit2/build \
&& cd /tmp/libgit2/build \
&& cmake .. \
&& make -j32 \
&& make install \
&& rm -rf /tmp/* \
&& echo "end"

# install boost.
RUN set -x \
&& apt update \
&& apt install -y libboost-all-dev \
&& apt clean all \
&& echo "end"
