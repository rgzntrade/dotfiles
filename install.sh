#!/usr/bin/env bash
#
# 开发环境自动化安装脚本（可重入 / re-entrant）
# 设计目标：重复运行安全 —— 已安装的组件自动跳过，单个步骤失败不阻断整体流程。
#
set -uo pipefail

# ----------------------------------------------------------------------------
# 基础设置
# ----------------------------------------------------------------------------
CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# cargo 安装的工具位于 ~/.cargo/bin，确保它在 PATH 中
export PATH="$HOME/.cargo/bin:$PATH"

# 日志辅助
info() { echo "==> [INFO] $*"; }
warn() { echo "==> [WARN] $*" >&2; }
ok()   { echo "    [OK]   $*"; }

have() { command -v "$1" >/dev/null 2>&1; }

# 判断包管理器
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PKG_MGR="apt"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PKG_MGR="brew"
else
  PKG_MGR="unknown"
fi

# apt 安装（存在性检查，可重入）
apt_install() {
  local pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    ok "apt: $pkg 已安装，跳过"
  else
    info "apt: 安装 $pkg ..."
    sudo apt-get install -y "$pkg" || warn "apt: $pkg 安装失败"
  fi
}

# 跨平台包安装：bin=命令名, pkg=包名
pkg_install() {
  local bin="$1" pkg="$2"
  if have "$bin"; then ok "$bin 已安装，跳过"; return; fi
  info "安装 $bin ($pkg) ..."
  case "$PKG_MGR" in
    apt)  sudo apt-get install -y "$pkg" || warn "$pkg 安装失败" ;;
    brew) brew install "$pkg" || warn "$pkg 安装失败" ;;
    *)    warn "未知包管理器，跳过 $pkg" ;;
  esac
}

# cargo 安装（存在性检查，可重入；编译失败不致命）
cargo_install() {
  local bin="$1"; shift
  if have "$bin"; then ok "cargo: $bin 已安装，跳过"; return; fi
  info "cargo: 安装 $bin ..."
  cargo install "$@" || warn "cargo: $bin 编译/安装失败（可能缺少系统依赖），继续后续步骤"
}

# ----------------------------------------------------------------------------
# 0. 更新 dotbot 子模块
# ----------------------------------------------------------------------------
info "初始化 dotbot 子模块 ..."
cd "$BASEDIR"
git -C "$DOTBOT_DIR" submodule sync --quiet --recursive || true
git submodule update --init --recursive || warn "子模块更新失败"

# ----------------------------------------------------------------------------
# 1. 系统软件源
# ----------------------------------------------------------------------------
if [[ "$PKG_MGR" == "apt" ]]; then
  info "更新 apt 软件源 ..."
  sudo apt-get update -y || warn "apt-get update 失败"
fi

# ----------------------------------------------------------------------------
# 2. 编译依赖（cargo GUI 程序需要）
# ----------------------------------------------------------------------------
if [[ "$PKG_MGR" == "apt" ]]; then
  for d in build-essential cmake pkg-config libfreetype6-dev libfontconfig1-dev \
           libxcb-xfixes0-dev libxkbcommon-dev libx11-dev libxcb1-dev libssl-dev; do
    apt_install "$d"
  done
fi

# ----------------------------------------------------------------------------
# 3. 基础工具
# ----------------------------------------------------------------------------
pkg_install cmake cmake

# zsh
if ! have zsh; then
  pkg_install zsh zsh
fi
# 将 zsh 设为默认 shell（幂等：已是 zsh 则跳过）
if have zsh; then
  current_shell="$(basename "${SHELL:-}")"
  if [[ "$current_shell" != "zsh" ]]; then
    zsh_bin="$(which zsh)"
    if grep -qx "$zsh_bin" /etc/shells; then
      info "将 zsh 设为默认 shell ($zsh_bin) ..."
      if chsh -s "$zsh_bin" 2>/dev/null \
         || sudo chsh -s "$zsh_bin" "$USER" 2>/dev/null; then
        ok "已设置 zsh 为默认 shell（重新登录后生效）"
      else
        warn "设置默认 shell 失败：请手动执行 'chsh -s $zsh_bin'（需要输入密码）"
      fi
    else
      warn "zsh 不在 /etc/shells，跳过设置默认 shell"
    fi
  else
    ok "zsh 已是默认 shell，跳过"
  fi
else
  warn "zsh 未安装，跳过设置默认 shell"
fi

pkg_install tmux tmux
pkg_install fd fd-find
if [[ "$PKG_MGR" == "apt" ]] && have fdfind && ! have fd; then
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi
pkg_install rg ripgrep
pkg_install autojump autojump
pkg_install xclip xclip
pkg_install sshfs sshfs
pkg_install python3 python3
apt_install python3-pip
apt_install python3-venv
apt_install luarocks

# plantuml / imv / feh
for p in plantuml imv feh; do
  pkg_install "$p" "$p"
done

# nodejs（通过 NodeSource）
if ! have node; then
  if [[ "$PKG_MGR" == "apt" ]]; then
    info "安装 nodejs (NodeSource 22.x) ..."
    curl -sL https://deb.nodesource.com/setup_22.x | sudo -E bash - || warn "NodeSource 配置失败"
    sudo apt-get install -y nodejs || warn "nodejs 安装失败"
  elif [[ "$PKG_MGR" == "brew" ]]; then
    brew install node || warn "node 安装失败"
  fi
else
  ok "node 已安装，跳过"
fi

# llvm
if ! have clang && [[ "$PKG_MGR" == "apt" ]]; then
  info "安装 LLVM（apt.llvm.org 脚本）..."
  sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" || warn "LLVM 安装失败"
elif have clang; then
  ok "clang 已安装，跳过"
fi

# fzf（从源码）
if [ ! -d "$HOME/.fzf" ]; then
  info "克隆 fzf ..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --all || warn "fzf 安装失败"
else
  ok "fzf 已安装，跳过"
fi

# ----------------------------------------------------------------------------
# 4. Rust 与 cargo 工具
# ----------------------------------------------------------------------------
if ! have rustc; then
  info "安装 Rust ..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# 确保 cargo 在当前 shell 可用
if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

cargo_install gitui gitui --locked
cargo_install alacritty alacritty --locked
cargo_install bob bob-nvim --locked
cargo_install zellij zellij --locked
cargo_install neovide --git https://github.com/neovide/neovide

# 校验 bob
if have bob; then
  ok "bob 已安装"
else
  warn "bob 未安装，无法继续安装 nvim"
fi

# ----------------------------------------------------------------------------
# 5. 通过 bob 安装 neovim
# ----------------------------------------------------------------------------
if have bob; then
  mkdir -p "$HOME/.local/share/bash-completion/completions"
  bob complete bash > "$HOME/.local/share/bash-completion/completions/bob" 2>/dev/null || true
  mkdir -p "${ZDOTDIR:-$HOME}/.zsh/completions"
  bob complete zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_bob" 2>/dev/null || true
  info "bob: 安装 stable nvim ..."
  bob install stable || warn "bob install stable 失败"
  bob use stable || warn "bob use stable 失败"
  # 让 nvim 命令可用（bob 的活跃二进制目录默认不在 PATH 中）
  mkdir -p "$HOME/.local/bin"
  ln -sf "$HOME/.local/share/bob/nvim-bin/nvim" "$HOME/.local/bin/nvim" \
    && ok "nvim 已链接到 ~/.local/bin/nvim" \
    || warn "nvim 链接失败"
fi

# ----------------------------------------------------------------------------
# 6. neovim 的辅助 provider
# ----------------------------------------------------------------------------
if have npm; then
  if npm ls -g neovim >/dev/null 2>&1; then
    ok "npm: neovim 已安装，跳过"
  else
    info "npm: 安装 neovim ..."
    npm install -g neovim || warn "npm neovim 安装失败"
  fi
fi
if ! have pip3; then
  info "pip3 缺失，尝试通过 ensurepip 用户级安装 pip ..."
  python3 -m ensurepip --user --upgrade || warn "ensurepip 失败，需通过 apt 安装 python3-pip"
fi
if have pip3; then
  if pip3 show neovim >/dev/null 2>&1; then
    ok "pip: neovim 已安装，跳过"
  else
    info "pip: 安装 neovim ..."
    pip3 install --user neovim || warn "pip neovim 安装失败"
  fi
else
  warn "pip3 仍不可用，跳过 neovim python provider（需 sudo apt-get install python3-pip）"
fi

# ----------------------------------------------------------------------------
# 7. 用 dotbot 链接配置文件
# ----------------------------------------------------------------------------
# 预创建可能需要的新配置目录（dotbot 链接嵌套路径时不会自动建父目录）
mkdir -p "$HOME/.config/alacritty"

info "使用 dotbot 链接配置文件 ..."
"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

info "安装流程结束。可重复运行本脚本以补全未完成/失败的部分。"
