# build this with
# docker build -t nielass/debian-dev-base .

FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

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
    clang \
    clangd \
    clang-format \
    cmake \
    curl \
    fzf \
    libfuse2 \
    gettext \
    gdb \
    git \
    ninja-build \
    pip \
    pylint \
    python3-venv \
    ripgrep \
    tree \
    unzip \
    wget \
    xclip \
    zip

# setup node & npm
RUN mkdir -p /root/tmp && cd /root/tmp \ 
    && curl -sL https://deb.nodesource.com/setup_18.x | bash \
    && apt install -y nodejs \
    && npm install -g vscode-langservers-extracted

# install zsh
RUN apt update \
    && apt install -y \
    autojump \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# download and install lazygit
RUN mkdir -p /root/tmp/lazygit
RUN cd /root/tmp/lazygit && curl --location --output $LG_FILENAME $LG_GITHUB
RUN cd /root/tmp/lazygit && tar xzvf $LG_FILENAME && mv $LG /usr/bin/

# install nvim
RUN mkdir -p /root/tmp \
    && cd /root/tmp \
    && wget -O nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
    && chmod +x nvim \
    && cp nvim /usr/local/bin

# install gtest
RUN mkdir -p /root/tmp \
    && cd /root/tmp \
    && git clone https://github.com/google/googletest.git -b v1.14.0 \
    && cd googletest \
    && cmake -B build \
    && cmake --build build -j12 \
    && cmake -E chdir "build" make install

# config files
# COPY ./config/nvim/ /root/.config/nvim/
RUN mkdir -p /root/.config && cd /root/.config \
    && git clone https://github.com/Whisillus/NvimConfig.git nvim
COPY ./home/ /root/

# change default shell for root
RUN chsh -s /usr/bin/zsh root

# remove tmp files
RUN rm -rf /root/tmp

# setup default dir, the project should be mounted here
WORKDIR /workspace

# setup CMD for new shell
CMD ["/usr/bin/zsh"]

