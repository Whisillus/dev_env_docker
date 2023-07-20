
FROM nielass/debian-dev

ARG DEBIAN_FRONTEND=noninteractive

RUN cd /root \
    && mkdir tmp \
    && cd tmp \
    && wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && zcat < install-tl-unx.tar.gz | tar xf - \
    && cd install-tl-* \
    && perl ./install-tl --no-interaction \
    && cd /workspace \
    && rm -rf /root/tmp

ENV PATH="${PATH}:/usr/local/texlive/2023/bin/x86_64-linux"

# setup default dir, the project should be mounted here
WORKDIR /workspace

# setup CMD for new shell
CMD ["/usr/bin/zsh"]

