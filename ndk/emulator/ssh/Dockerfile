FROM huaixiaoz/andocker:latest

MAINTAINER huaixiaoz "hello@ifnot.cc"

# Install sshd
# Install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install \
  openssh-server \
  psmisc htop vim cloc \
  -y && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

# Setup environment
RUN useradd --shell /bin/bash --home-dir /opt/workspace --create-home --password hello hello

# Exec sshd
RUN mkdir /var/run/sshd && \
  echo 'root:root' | chpasswd && \
  echo 'hello:world' | chpasswd && \
  sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
  sed -ri 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
