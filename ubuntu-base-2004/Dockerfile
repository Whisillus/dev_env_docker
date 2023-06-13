
# build this with
# docker build -t nielass/ros-noetic .

FROM ubuntu:20.04
# FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

# todo: git setup?

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
    clang-format \
    cmake \
    curl \
    fzf \
    gettext \
    gdb \
    git \
    locales \
    locales-all \
    ninja-build \
    nodejs \
    npm \
    pip \
    pylint \
    python3 \
    python3-autopep8 \
    python3-venv\
    ripgrep \
    tree \
    unzip \
    xclip \
    wget \
    zip

# install zsh
RUN apt update \
    && apt install -y \
    autojump \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# for download and setup
RUN mkdir -p /root/tmp

# download and install lazygit
RUN mkdir -p /root/tmp/lazygit
RUN cd /root/tmp/lazygit && curl --location --output $LG_FILENAME $LG_GITHUB
RUN cd /root/tmp/lazygit && tar xzvf $LG_FILENAME && mv $LG /usr/bin/

# cooperate nvim 
RUN pip3 install pynvim
RUN npm install -g neovim

# install nvim
RUN cd /root/tmp && git clone https://github.com/neovim/neovim neovim
RUN cd /root/tmp/neovim && git checkout stable \
    && make -j4 CMAKE_BUILD_TYPE=Release \
    && make install

# copy config files
COPY ./config/nvim/ /root/.config/nvim/
COPY ./home/ /root/

# download and install nvim Packer
RUN git clone --depth 1 \
    https://github.com/wbthomason/packer.nvim \
    /root/.local/share/nvim/site/pack/packer/start/packer.nvim

# install nvim plugins
# todo: issue here: https://github.com/wbthomason/packer.nvim/issues/502
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# change default shell for root
RUN chsh -s /usr/bin/zsh root

# remove tmp files
RUN rm -rf /root/tmp
# RUN rm -rf /var/lib/apt/lists/*

# setup default dir, the project should be mounted here
WORKDIR /workspace

# setup CMD for new shell
CMD ["/usr/bin/zsh"]

