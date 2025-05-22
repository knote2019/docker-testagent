FROM 10.150.9.98:80/devops_tools/ubuntu22.04-testagent:master
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

#-----------------------------------------------------------------------------------------------------------------------
# install torch.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/pytorch/libtorch-cxx11-abi-shared-with-deps-2.4.1+cpu.zip -P /tmp \
&& unzip /tmp/libtorch-cxx11-abi-shared-with-deps-2.4.1+cpu.zip -d /usr/local \
&& mv /usr/local/libtorch /usr/local/torch \
&& rm -rf /tmp/* \
&& echo "end"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/torch/lib
