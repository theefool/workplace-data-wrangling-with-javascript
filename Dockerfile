FROM ubuntu:20.04

RUN apt-get -y update
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install nodejs npm
RUN apt-get -y install git
RUN npm install -g bower

RUN echo 'root:root' | chpasswd
RUN useradd -m user && \
    echo 'user:user' | chpasswd && \
    usermod -aG sudo user
