
FROM rtabmap/frontier2022

ARG DEBIAN_FRONTEND=noninteractive

# install ROS noetic
RUN /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc \
    | apt-key add -

RUN apt update \
    && apt install -y \
    ros-noetic-desktop-full \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential

RUN apt update \
    && apt install -y \
    clang-format \
    cmake \
    curl \
    fzf \
    gettext \
    gdb \
    git \
    locales \
    locales-all \
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

# ROS zsh setup
RUN echo 'source /opt/ros/noetic/setup.zsh' >> /root/.zshrc

# setup default dir, the project should be mounted here
WORKDIR /workspace

# setup CMD for new shell
CMD ["/usr/bin/zsh"]

