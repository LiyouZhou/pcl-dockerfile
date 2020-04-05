FROM ubuntu:18.04
LABEL maintainer="leothemagnificent@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

# install prerequisits
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential linux-libc-dev \
    cmake cmake-gui \
    libusb-1.0-0-dev libusb-dev libudev-dev \
    mpi-default-dev openmpi-bin openmpi-common \
    libflann1.9 libflann-dev \
    libeigen3-dev \
    libboost-all-dev \
    libvtk6.3-qt libvtk6.3 libvtk6-dev \
    libqhull* libgtest-dev \
    freeglut3-dev pkg-config \
    libxmu-dev libxi-dev \
    openjdk-8-jdk openjdk-8-jre \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

# build PCL and install
RUN cd /opt \
    && git clone https://github.com/PointCloudLibrary/pcl.git pcl-trunk \
    && ln -s /opt/pcl-trunk /opt/pcl \
    && cd /opt/pcl && git checkout pcl-1.10.1 \
    && mkdir -p /opt/pcl-trunk/release \
    && cd /opt/pcl/release && cmake -DCMAKE_BUILD_TYPE=None -DBUILD_GPU=ON -DBUILD_apps=ON -DBUILD_examples=ON .. \
    && cd /opt/pcl/release && make -j3 \
    && cd /opt/pcl/release && make install \
    && cd /opt/pcl/release && make clean