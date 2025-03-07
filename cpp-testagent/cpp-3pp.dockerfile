FROM 10.150.9.98:80/devops_tools/core-testagent:master
#-----------------------------------------------------------------------------------------------------------------------
# install pybind11.
RUN set -x \
&& git clone -b v2.13.6 https://github.com/pybind/pybind11.git /tmp/pybind11 \
&& mkdir /tmp/pybind11/build \
&& cd /tmp/pybind11/build \
&& cmake -DPYBIND11_PYTHON_VERSION=3.10 .. \
&& make -j32 \
&& make install \
&& rm -rf /tmp/* \
&& echo "end"
