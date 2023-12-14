#!/bin/bash

# 安装必需的软件包
sudo add-apt-repository ppa:kitware/cmake
sudo apt-get update
sudo apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config
curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y python3 python3-pip automake nodejs npm python3.8-venv curl
sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev 

sudo npm install -g npm@10.2.1

# 克隆 tmux 仓库
git clone https://github.com/tmux/tmux.git
cd tmux

# 运行 autogen.sh
sh autogen.sh

# 配置和构建 tmux
./configure
make

# 安装 tmux
sudo make install

# 清理临时文件
cd ..
rm -rf tmux

