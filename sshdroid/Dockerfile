FROM huaixiaoz/andocker:latest
MAINTAINER huaixiaoz "hello@itmp.top"

# Setup environment
RUN mv /root/.bashrc /root/.bashrc~
COPY ./.bashrc /root/.bashrc
#ENV ANDROID_HOME /opt/android-sdk-linux
#ENV ANDROID_NDK_HOME /opt/android-ndk-r11c
#ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tool

# Update
RUN apt-get update && apt-get upgrade -y

# Clean
RUN apt-get clean

# Exec sshd
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config

EXPOSE 22
WORKDIR /opt/workspace
CMD ["/usr/sbin/sshd", "-D"]
