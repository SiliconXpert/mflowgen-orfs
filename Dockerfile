# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Kolkata

RUN apt-get update; apt-get -y install curl

RUN apt-get install -y build-essential git clang bison flex \
    libreadline-dev gawk tcl-dev libffi-dev git \
    graphviz xdot pkg-config python3 libboost-system-dev \
    libboost-python-dev libboost-filesystem-dev zlib1g-dev cmake swig wget

RUN apt-get update && apt-get install -y \
    libqt5charts5 \
    libqt5core5a \
    libqt5gui5 \
    libqt5widgets5 \
    tcl-tclreadline


# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    time \
    ca-certificates \
    tzdata \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /orsf

# Download and install OpenROAD
RUN wget -c https://github.com/Precision-Innovations/OpenROAD/releases/download/2024-12-14/openroad_2.0-17598-ga008522d8_amd64-ubuntu-22.04.deb \
    && apt-get install -y ./openroad_2.0-17598-ga008522d8_amd64-ubuntu-22.04.deb \
    && rm openroad_2.0-17598-ga008522d8_amd64-ubuntu-22.04.deb

# Download and extract OSS-CAD-Suite
RUN wget -O oss-cad-suite.tgz https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-02-14/oss-cad-suite-linux-x64-20250214.tgz \
    && tar -xvzf oss-cad-suite.tgz \
    && rm oss-cad-suite.tgz

# Set OSS-CAD-Suite binaries in PATH
ENV PATH="/orsf/oss-cad-suite/bin:${PATH}"

# Clone OpenROAD-flow-scripts
RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git /OpenROAD-flow-scripts

# Set environment variables for OpenROAD and Yosys
# RUN echo 'export OPENROAD_EXE=$(command -v openroad)' >> ~/.bashrc \
#     && echo 'export YOSYS_EXE=$(command -v yosys)' >> ~/.bashrc


ENV OPENROAD_EXE=/usr/bin/openroad
ENV YOSYS_EXE=/orsf/oss-cad-suite/bin/yosys 

# Set working directory for build
WORKDIR /OpenROAD-flow-scripts

# Remove existing designs
RUN rm -rf flow/designs/*



# avoid issues with permissions
RUN chmod o+rw -R /OpenROAD-flow-scripts

# Build OpenROAD-flow-scripts
# RUN make