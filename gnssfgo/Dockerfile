FROM whisillus/humble

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

# install dep
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
    libgoogle-glog-dev \
    ros-humble-geographic-msgs \
    ros-humble-marti-nav-msgs \
    libgeos++-dev  \
    libgeos3.10.2  \
    libgeos-c1v5  \
    libgeos-dev  \
    libgeos-doc

# some setup
RUN cd /usr/local/include \ 
    && ln -sf /usr/include/eigen3/Eigen Eigen \
    && ln -sf /usr/include/eigen3/unsupported unsupported

# install adapted gtsam
RUN mkdir -p /root/thirdparty \
    && cd /root/thirdparty \
    && git clone https://github.com/rwth-irt/gtsam.git \
    && cd gtsam \
    && cmake -B build -DGTSAM_USE_SYSTEM_EIGEN=ON \
    && cmake --build build -j \
    && cmake -E chdir "build" make install -j

# install adapted mapviz
RUN mkdir -p /root/mapviz_ws/src \
    && cd /root/mapviz_ws/src \
    && git clone -b humble-dev https://github.com/rwth-irt/mapviz.git \
    && git clone https://github.com/swri-robotics/marti_common.git \
    && git clone https://github.com/swri-robotics/marti_messages.git \
    && cd /root/mapviz_ws \
    && source /opt/ros/humble/setup.bash \
    && colcon build


# setup default dir, the project should be mounted here
WORKDIR /workspace

# setup CMD for new shell
CMD ["/usr/bin/zsh"]



