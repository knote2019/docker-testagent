FROM 10.150.9.98:80/devops_tools/ubuntu22.04-testagent:master
RUN wget -nv http://10.113.3.1/corex/toolbox/ide/clion.key -P /root/.config/JetBrains/CLion2023.3
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

# install cuda.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cuda/cuda_12.4.1_550.54.15_linux.run -P /tmp \
&& bash /tmp/cuda_12.4.1_550.54.15_linux.run --toolkit --silent \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-compute.desktop \
&& sed -i 's/Categories.*/Catagories=CUDA/' /usr/share/applications/nsight-systems.desktop \
&& sed -i "s,host-linux-x64/nsight-sys,host-linux-x64/nsys-ui,g" /usr/share/applications/nsight-systems.desktop  \
&& rm -f /usr/share/applications/nsight.desktop \
&& rm -f /usr/share/applications/nvvp.desktop \
&& rm -rf /tmp/* \
&& echo "end"
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

# install cudnn.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/cudnn/cudnn-linux-x86_64-8.9.5.30_cuda12-archive.tar.xz -P /tmp \
&& tar -xf /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive.tar.xz -C /tmp \
&& cp -r /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive/include/* /usr/local/cuda/include \
&& cp -r /tmp/cudnn-linux-x86_64-8.9.5.30_cuda12-archive/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

# install nccl.
RUN set -x \
&& wget -nv http://10.113.3.1/corex/toolbox/nccl/nccl_2.21.5-1+cuda12.4_x86_64.txz -P /tmp \
&& tar -xf /tmp/nccl_2.21.5-1+cuda12.4_x86_64.txz -C /tmp \
&& cp -r /tmp/nccl_2.21.5-1+cuda12.4_x86_64/include/* /usr/local/cuda/include \
&& cp -r /tmp/nccl_2.21.5-1+cuda12.4_x86_64/lib/* /usr/local/cuda/lib64 \
&& rm -rf /tmp/* \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install torch-requirements.
RUN set -x \
&& git clone -b master --recursive --depth=1 https://github.com/knote2019/torch-v2.4.1.git /opt/torch \
&& pip install -r /opt/torch/requirements.txt \
&& echo "end"

# force build.
ARG FORCE_BUILD

#-----------------------------------------------------------------------------------------------------------------------
# install torch.
ENV TORCH_CUDA_ARCH_LIST="8.0"
RUN set -x \
&& pip install cmake==3.31.6 \
&& pip install ninja \
&& pip install mkl-static \
&& pip install mkl-include \
&& export DEBUG=OFF \
&& export USE_NINJA=ON \
&& export USE_CUDA=ON \
&& export CUDA_HOME=/usr/local/cuda \
&& export USE_CUDNN=ON \
&& export CUDNN_LIBRARY=/usr/local/cuda \
&& export CUDNN_INCLUDE_DIR=/usr/local/cuda/include \
&& export CUDNN_LIB_DIR=/usr/local/cuda/lib64 \
&& export USE_NCCL=ON \
&& export USE_SYSTEM_NCCL=ON \
&& export NCCL_ROOT=/usr/local/cuda \
&& export NCCL_INCLUDE_DIR=/usr/local/cuda/include \
&& export NCCL_LIB_DIR=/usr/local/cuda/lib64 \
&& export USE_DISTRIBUTED=ON \
&& export USE_C10D_NCCL=ON \
&& export USE_FLASH_ATTENTION=ON \
&& export BUILD_SHARED_LIBS=ON \
&& export BUILD_TEST=OFF \
&& export USE_MKLDNN=ON \
&& export USE_FBGEMM=ON \
&& pip install /opt/torch --no-build-isolation --verbose \
&& mkdir /usr/local/torch \
&& ln -sf /usr/local/lib/python3.*/dist-packages/torch/include /usr/local/torch/include \
&& ln -sf /usr/local/lib/python3.*/dist-packages/torch/lib /usr/local/torch/lib \
&& rm -rf /tmp/* \
&& echo "end"
