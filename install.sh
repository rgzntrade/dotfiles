#!/usr/bash

set -e

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 更新自仓库
cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
# git submodule update --init --recursive "${DOTBOT_DIR}"
# git submodule update --init --recursive 



# 安装 cmake
echo "Installing cmake..."
if command -v cmake >/dev/null 2>&1; then
  echo "cmake is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y cmake
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install cmake
  fi
fi

# 安装 zsh
echo "Installing zsh..."
if command -v zsh >/dev/null 2>&1; then
  echo "zsh is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y zsh
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install zsh
  fi
fi

# 安装 tmux
# echo "Installing tmux..."
# if command -v tmux >/dev/null 2>&1; then
#   echo "tmux is already installed. Skipping."
# else
#   if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#     sudo apt-get install -y tmux
#   elif [[ "$OSTYPE" == "darwin"* ]]; then
#     brew install tmux
#   fi
# fi

# Check if Rust is installed
if ! command -v rustc &> /dev/null; then
	    echo "Rust is not installed. Installing Rust..."
	        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		    source $HOME/.cargo/env
	    else
		        echo "Rust is already installed. Skipping."
fi

# Check if Cargo is installed
if ! command -v cargo &> /dev/null; then
	    echo "Cargo is not installed. Something went wrong with Rust installation."
	        exit 1
fi

# Install Gitui using Cargo
echo "Installing gitui..."
cargo install gitui

# Install Bob-nvim using Cargo
echo "Installing Bob-nvim..."
cargo install bob-nvim

# Verify Bob-nvim installation
if command -v bob &> /dev/null; then
	    echo "Bob is installed successfully."
    else
	        echo "Bob installation failed."
		    exit 1
fi


# 使用 bob 安装最新版 nvim
echo "Installing latest nvim..."
if command -v bob >/dev/null 2>&1; then
  bob complete bash
  bob complete zsh
  bob install stable
  bob use stable
else
  echo "bob is not installed. Skipping nvim installation."
fi

echo "Installation completed."

#安装 fd-find
echo "Installing fd-find..."
if command -v fd >/dev/null 2>&1; then
  echo "fd-find is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y fd-find
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fd
  else
    echo "Unsupported operating system. Cannot install fd-find."
  fi
fi


# 安装 ripgrep
echo "Installing ripgrep..."
if command -v rg >/dev/null 2>&1; then
  echo "ripgrep is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y ripgrep
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install ripgrep

  else
    echo "Unsupported operating system. Cannot install ripgrep."

  fi
fi

# 安装 tmux-cssh 插件
# echo "Installing tmux-cssh plugin..."
# if [[ -d "$HOME/.tmux/plugins/tmux-cssh" ]]; then
#   echo "tmux-cssh plugin is already installed. Skipping."
#
# else
#   git clone https://github.com/dennishafemann/tmux-cssh "$HOME/.tmux/plugins/tmux-cssh"
# fi

# 安装 zsh 依赖 - autojump
echo "Installing autojump..."
if command -v autojump >/dev/null 2>&1; then

  echo "autojump is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y autojump
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install autojump
  else
    echo "Unsupported operating system. Cannot install autojump."
  fi
fi


# 使用dotbot配置
"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"


echo "Installation completed."
