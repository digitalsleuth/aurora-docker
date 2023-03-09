# Docker Image for cyb3rfox's Aurora Incident Response

FROM ubuntu:22.04

LABEL version="1.0.0"
LABEL description="Aurora Incident Response Docker"
LABEL maintainer="https://github.com/digitalsleuth/"
ARG AURORA_VERSION=0.6.6

ENV TERM linux
SHELL ["/bin/bash", "-ec"]

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && apt-get install curl wget sudo ssh nano less xxd -y
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get install -y nodejs libglib2.0-0 libnss3-dev libgtk-3-dev libxss-dev libasound2-dev unzip

RUN echo "    X11Forwarding yes" >> /etc/ssh/ssh_config && \
echo "    X11DisplayOffset 10" >> /etc/ssh/ssh_config && \
echo "    PrintMotd no" >> /etc/ssh/ssh_config && \
echo "    PrintLastLog yes" >> /etc/ssh/ssh_config && \
echo "    TCPKeepAlive yes" >> /etc/ssh/ssh_config && \
echo "    ForwardX11 yes" >> /etc/ssh/ssh_config && \
echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

RUN groupadd -r aurora -g 1000 && \
useradd -r -u 1000 -g aurora -d /home/aurora -s /bin/bash -c "Aurora User" aurora && \
mkdir /home/aurora && \
chown -R aurora:aurora /home/aurora && \
usermod -a -G sudo aurora && \
echo 'aurora:aurora' | chpasswd

RUN cd /home/aurora && wget https://github.com/cyb3rfox/Aurora-Incident-Response/releases/download/${AURORA_VERSION}/Aurora-linux-x64-${AURORA_VERSION}.zip && \
    unzip -d /home/aurora/ Aurora-linux-x64-${AURORA_VERSION}.zip && \
    mv /home/aurora/Aurora-linux-x64 /usr/local/bin/Aurora && \
    rm /home/aurora/Aurora-linux-x64-${AURORA_VERSION}.zip && \
    chown -R aurora:aurora /home/aurora && \
    ln -s /usr/local/bin/Aurora/Aurora /usr/local/bin/aurora

WORKDIR /home/aurora

RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
