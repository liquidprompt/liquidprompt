FROM registry.fedoraproject.org/fedora:44

RUN dnf install -y \
    bash \
    zsh \
    tmux \
    git \
    procps-ng \
    perl \
    && dnf clean all

WORKDIR /liquidprompt
COPY . /liquidprompt

CMD ["/bin/bash"]
