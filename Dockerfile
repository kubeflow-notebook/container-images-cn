ARG BASE_IMAGE=kubeflownotebookswg/jupyter-pytorch-cuda-full
ARG KUBEFLOW_VERSION=v1.8.0

FROM ${BASE_IMAGE}:${KUBEFLOW_VERSION}

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
      git-lfs \
      openssh-client \
      openssh-server \
      sudo

# Install git LFS
RUN git lfs install

# Install Oh My Zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell

# Disbale root login
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

# Enable pubkey authentication
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

# Disable password authentication
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd

# Make $NB_USER a sudoer
RUN adduser $NB_USER sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $NB_USER

EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]
