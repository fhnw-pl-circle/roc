FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
  libc-dev binutils git wget rustc cargo build-essential clang sudo

RUN wget https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-linux_x86_64-latest.tar.gz -O /tmp/roc.tar.gz && \
  mkdir -p /opt && tar -xvf /tmp/roc.tar.gz -C /opt/ && \
  mv "/opt/$(ls /opt | grep roc_nightly-linux_x86_64)" /opt/roc && \
  usermod -aG sudo ubuntu && \
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ubuntu

WORKDIR /home/ubuntu

# The tar file is extracted to /opt/roc/roc_nightly-linux_x86_64-{date}-{commit}
# We need to add the bin directory to the PATH, but we don't know the exact path
# so we need to find it by using ls on the directory
RUN echo "export PATH=\$PATH:/opt/roc/" >> /home/ubuntu/.bashrc
