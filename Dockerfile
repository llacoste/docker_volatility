FROM ubuntu
MAINTAINER me

# How to run
# docker run -v <abs_path_to_memory_samples>:/data -i -t

# Update system
RUN apt-get update

# Install prereqs
RUN apt-get install -y \
    wget \
    unzip \
    git \
    vim \
    software-properties-common \
    build-essential

# Install python
RUN apt-get install -y \
    python \
    python-dev \
    python-openpyxl \
    python-support \
    python-coverage \
    python-nose

# Install yara
RUN apt-get install -y \
    libyara2 \
    yara \
    python-yara

# Install dump tools
RUN apt-get install -y dwarfdump 

# Install distorm
RUN cd /opt && \
    wget http://distorm.googlecode.com/files/distorm3.zip && \
    unzip distorm3.zip && \
    cd distorm3 && \
    python setup.py build && \
    python setup.py build install

# Install pycrypto
RUN cd /opt && \
    wget https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz && \
    tar -xvzf pycrypto-2.6.1.tar.gz && \
    cd pycrypto-2.6.1 && \
    python setup.py build && \
    python setup.py build install

# Install volatility
RUN cd /opt && \
    git clone https://github.com/volatilityfoundation/volatility.git && \
    cd volatility && \
    python setup.py build

# Add more profiles
COPY volatility-profiles/* /opt/volatility/volatility/plugins/overlays/linux/

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm /opt/distorm3.zip
RUN rm /opt/pycrypto-2.6.1.tar.gz

RUN echo 'alias volatility="python /opt/volatility/vol.py"' >> /etc/bash.bashrc

# Define mountable directories
VOLUME ["/data"]

# Define working directory
WORKDIR /data