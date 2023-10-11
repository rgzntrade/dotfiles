#!/bin/bash

# 安装必需的软件包
sudo apt-get update
sudo apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config
sudo apt-get install -y automake nodejs npm python3.8-venv curl
sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

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

