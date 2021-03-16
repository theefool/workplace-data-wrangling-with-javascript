FROM ubuntu:20.04

RUN apt -y update
RUN apt -y upgrade
RUN DEBIAN_FRONTEND=noninteractive \
    apt -y install nodejs npm

RUN echo 'root:root' | chpasswd
RUN useradd -m user && \
    echo 'user:user' | chpasswd && \
    usermod -aG sudo user
