
FROM debian:stable

ARG DEBIAN_FRONTEND=noninteractive

# todo: git setup?
# todo: install nvim plugin
# todo: move files

# We use lazygit
ARG LG='lazygit'
ARG LG_GITHUB='https://github.com/jesseduffield/lazygit/releases/download/v0.38.2/lazygit_0.38.2_Linux_x86_64.tar.gz'
ARG LG_FILENAME='lazygit.tar.gz'

# set locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ=Europe/Berlin

# apt install basic software
RUN apt update \
    && apt install -y \
    build-essential \
    cmake \
    curl \
    fzf \
    gettext \
    gdb \
    git \
    ninja-build \
    nodejs \
    npm \
    pip \
    python3 \
    ripgrep \
    tree \
    unzip \
    xclip \
    zip

# for download and setup
RUN mkdir -p /root/tmp

# download and install lazygit
RUN mkdir -p /root/tmp/lazygit
RUN cd /root/tmp/lazygit && curl --location --output $LG_FILENAME $LG_GITHUB
RUN cd /root/tmp/lazygit && tar xzvf $LG_FILENAME && mv $LG /usr/bin/

# cooperate nvim with python3
RUN pip3 install pynvim

# install nvim
RUN cd /root/tmp && git clone https://github.com/neovim/neovim neovim
RUN cd /root/tmp/neovim && git checkout stable \
    && make -j4 CMAKE_BUILD_TYPE=Release \
    && make install

# download nvim Packer
RUN git clone --depth 1 \
    https://github.com/wbthomason/packer.nvim \
    /root/.local/share/nvim/site/pack/packer/start/packer.nvim

# remove tmp files
RUN rm -rf /root/tmp

# setup default dir, the project should be mounted here
WORKDIR /root/workspace

# setup CMD
# CMD ["tail", "-f", "/dev/null"]
