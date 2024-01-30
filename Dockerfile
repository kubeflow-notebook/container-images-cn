# Use a Jupyter notebook image from Kubeflow as the base image
ARG BASE_IMAGE=kubeflownotebookswg/jupyter

# Specify the version of Kubeflow
ARG KUBEFLOW_VERSION=v1.8.0

# Build a new image from the specified base image and version
FROM ${BASE_IMAGE}:${KUBEFLOW_VERSION}

# Switch to root user to perform system-level operations
USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
      git-lfs \
      openssh-client \
      openssh-server \
      sudo \
      tmux

# Install Git Large File Storage (LFS) for handling large files
RUN git lfs install

# Create a directory for SSH connections
RUN mkdir -p /var/run/sshd

# Disable root user login via SSH
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

# Enable public key authentication for SSH
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

# Disable password authentication for SSH
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

# Make the default Jupyter notebook user a sudoer without a password requirement
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NB_USER

# Switch back to the default Jupyter notebook user
USER $NB_USER

CMD ["sudo", "/usr/sbin/sshd", "-D"]
