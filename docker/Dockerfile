FROM ubuntu:24.04

ARG USERNAME
ARG UID

RUN sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install file build-essential libncurses5-dev \
      git bzr cvs subversion unzip bc swig iputils-ping \
      sudo wget cpio rsync dosfstools python3-setuptools \
      python3-dev libssl-dev \
      vim less && \
    apt-get -y autoremove && \
    apt-get -y clean

# Now sudo and the sudo group exist — safe to create the user and policy
RUN EXISTING_USER=$(getent passwd | awk -F: -v uid="$UID" '$3 == uid {print $1}') && \
    if [ -z "$EXISTING_USER" ]; then \
       useradd --uid ${UID} --create-home --shell /bin/bash -G sudo,root ${USERNAME}; \
    fi && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd && \
    chmod 440 /etc/sudoers.d/nopasswd

RUN mkdir /workdir && chown ${USERNAME} /workdir
WORKDIR /workdir
ENV HOME /workdir
COPY br-build.sh .
