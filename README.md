# Container Images for Kubeflow Notebooks

Based on the [official image](https://www.kubeflow.org/docs/components/notebooks/container-images/).

Add the following features:

1. Make $NB_USER a sudoer.
2. Add `openssh-server` and configure it to allow only public key login.
3. Add `openssh-client` and `git-lfs` to make it easier to pull large models.
