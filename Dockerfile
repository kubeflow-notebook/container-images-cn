ARG BASE_IMAGE=kubeflownotebookswg/jupyter-pytorch-cuda-full
ARG KUBEFLOW_VERSION=v1.8.0

FROM ${BASE_IMAGE}:${KUBEFLOW_VERSION}

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
      openssh-client \
      openssh-server \
      git-lfs

# Install git LFS
RUN git lfs install

# Permit root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Disable password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
