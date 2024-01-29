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

# Disable password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd

# Make $NB_USER a sudoer
RUN adduser $NB_USER sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $NB_USER

RUN mkdir -p $HOME/.ssh && \
    touch $HOME/.ssh/authorized_keys && \
    chmod 700 $HOME/.ssh && chmod 600 $HOME/.ssh/authorized_keys

EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]
