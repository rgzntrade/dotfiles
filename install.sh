#!/usr/bin/env bash

set -e

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 更新自仓库
cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
# git submodule update --init --recursive "${DOTBOT_DIR}"
git submodule update --init --recursive 



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
echo "Installing tmux..."
if command -v tmux >/dev/null 2>&1; then
  echo "tmux is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y tmux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install tmux
  fi
fi

# 安装 bob
echo "Installing bob..."
if command -v bob >/dev/null 2>&1; then
  echo "bob is already installed. Skipping."
else
  if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
    if ! command -v curl >/dev/null 2>&1; then
      echo "curl is not installed. Installing curl..."
      if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install -y curl
      elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install curl
      fi
    fi
    bash <(curl -sL https://github.com/ripper2hl/bob/raw/master/install.sh)
  else
    echo "Unsupported operating system: $OSTYPE. Skipping bob installation."
  fi
fi

# 使用 bob 安装最新版 nvim
echo "Installing latest nvim..."
if command -v bob >/dev/null 2>&1; then
  bob install nvim
else
  echo "bob is not installed. Skipping nvim installation."
fi

echo "Installation completed."

# 使用dotbot配置
"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
