
FROM nvcr.io/nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

# apt install basic software
RUN apt update \
    && apt upgrade -y \
    && apt install -y \
    build-essential \
    clang \
    clangd \
    clang-format \
    cmake \
    curl \
    fzf \
    language-pack-en-base \
    libfuse2 \
    libgtk2.0-dev \
    gettext \
    gdb \
    git \
    ninja-build \
    pip \
    pylint \
    python3-venv \
    ripgrep \
    tree \
    unzip \
    wget \
    xclip \
    zip

# setup node & npm
RUN mkdir -p /root/tmp && cd /root/tmp \ 
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt update \
    && apt install -y nodejs \
    && npm install -g vscode-langservers-extracted

# setup pytorch, should use with CUDA 12.1
RUN pip3 install \
    torch \
    torchvision \
    torchaudio \
    numpy==1.26.4 \
    onnx \
    onnxruntime

# install ros2 humble
RUN apt update \
    && apt install -y \
    software-properties-common \
    && add-apt-repository \
    universe \
    && apt update \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
    ros-humble-desktop \
    ros-dev-tools

# install gnssfgo dep
RUN apt update \
    && apt install -y \
    freeglut3-dev \
    mesa-utils \
    ros-humble-ublox-serialization \
    libgeographic-dev \
    ros-humble-pcl-msgs \
    ros-humble-pcl-conversions \
    ros-humble-gps-msgs \
    ros-humble-nmea-msgs \
    ros-humble-novatel-gps-driver \
    ros-humble-novatel-gps-msgs \
    ros-humble-camera-calibration-parsers \
    libgoogle-glog-dev \
    ros-humble-geographic-msgs \
    ros-humble-marti-nav-msgs \
    libgeos++-dev  \
    libgeos3.10.2  \
    libgeos-c1v5  \
    libgeos-dev  \
    libgeos-doc \
    xterm

# some setup
RUN cd /usr/local/include \ 
    && ln -sf /usr/include/eigen3/Eigen Eigen \
    && ln -sf /usr/include/eigen3/unsupported unsupported

# build NumCpp
RUN mkdir -p /root/thirdparty \
    && cd /root/thirdparty \ 
    && git clone https://github.com/dpilger26/NumCpp.git \
    && cd /root/thirdparty/NumCpp \
    && cmake -B build \ 
    && cmake --build build --target install 

# install adapted mapviz
RUN mkdir -p /root/mapviz_ws/src \
    && cd /root/mapviz_ws/src \
    && git clone -b humble-dev https://github.com/rwth-irt/mapviz.git \
    && git clone https://github.com/swri-robotics/marti_common.git \
    && git clone https://github.com/swri-robotics/marti_messages.git \
    && cd /root/mapviz_ws \
    && source /opt/ros/humble/setup.bash \
    && colcon build

# build adapted gtsam
RUN mkdir -p /root/thirdparty \
    && cd /root/thirdparty \
    && git clone -b gnssFGO --depth 1 https://github.com/rwth-irt/gtsam.git \
    && cd /root/thirdparty/gtsam \
    && cmake -B build -DGTSAM_USE_SYSTEM_EIGEN=ON \
    && cmake --build build -j \
    && cmake -E chdir "build" make install -j

# install gtest
RUN mkdir -p /root/tmp \
    && cd /root/tmp \
    && git clone https://github.com/google/googletest.git -b v1.14.0 \
    && cd googletest \
    && cmake -B build \
    && cmake --build build -j12 \
    && cmake -E chdir "build" make install

# ---------- core part end here --------------
# ---------- here comes dev tools --------------

# install zsh
RUN apt update \
    && apt install -y \
    autojump \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# download and install lazygit
ARG LG='lazygit'
ARG LG_GITHUB='https://github.com/jesseduffield/lazygit/releases/download/v0.38.2/lazygit_0.38.2_Linux_x86_64.tar.gz'
ARG LG_FILENAME='lazygit.tar.gz'
RUN mkdir -p /root/tmp/lazygit \ 
    && cd /root/tmp/lazygit \ 
    && curl --location --output $LG_FILENAME $LG_GITHUB \
    && tar xzvf $LG_FILENAME \
    && mv $LG /usr/bin/

# install nvim
RUN mkdir -p /root/tmp \
    && cd /root/tmp \
    && wget -O nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
    && chmod +x nvim \
    && cp nvim /usr/local/bin

# config files
# COPY ./config/nvim/ /root/.config/nvim/
RUN mkdir -p /root/.config \
    && cd /root/.config \
    && git clone https://github.com/Whisillus/NvimConfig.git nvim
COPY ./home/ /root/

# remove tmp files
RUN rm -rf /root/tmp

# setup default dir, the project should be mounted here
WORKDIR /workspace

# addtional requirement
# OpenCV
# Tensorrt
# libTorch

# setup CMD for new shell
CMD ["/usr/bin/bash"]


