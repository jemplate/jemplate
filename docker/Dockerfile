FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        bash \
        build-essential \
        curl \
        emacs \
        git \
        golang \
        less \
        libtemplate-perl \
        locales \
        perl \
        python3 \
        python3-pip \
        silversearcher-ag \
        tig \
        tmux \
        vim \
        wget \
 && true

RUN pip3 install pyyaml

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
 && locale-gen en_US.UTF-8 \
 && true

RUN useradd -m me

USER me

COPY bashrc /home/me/.bashrc

WORKDIR /jemplate/
