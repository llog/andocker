FROM huaixiaoz/andocker:ssh

MAINTAINER huaixiaoz "hello@ifnot.cc"

ARG ROOT_PASSWORD
RUN echo "root:$ROOT_PASSWORD" | chpasswd && \
  echo "hello:$ROOT_PASSWORD" | chpasswd
