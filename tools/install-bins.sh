#!/usr/bin/env bash
# ==========================================
# no-sudo 사용자 로컬 바이너리 설치기
# ==========================================
# 정적 바이너리를 ~/.local/bin 에 받습니다. sudo / 패키지매니저 불필요.
# sudo 없는 공용 머신 · 개인 머신 · 낯선 SSH 박스 어디서나 동일하게 동작.
#
# 사용법:  ./tools/install-bins.sh              # 빠진 것만 설치
#          ./tools/install-bins.sh --force      # 이미 있어도 다시 받기
#          ./tools/install-bins.sh --minimal    # 폰트 스킵 (헤드리스/서버용)
#
# config(nvim/zsh 등)는 이 바이너리가 없어도 폴백으로 동작하므로, 이 스크립트는
# "필수"가 아니라 "검색·프롬프트·꾸미기를 위한 선택적 업그레이드" 입니다.
#
# 예외(이 스크립트가 다루지 않는 것): zsh 셸 자체, wl-clipboard 는 정적배포가
# 마땅치 않아 apt 로 설치하세요:  sudo apt install zsh wl-clipboard

set -uo pipefail

BIN_DIR="${HOME}/.local/bin"
FORCE=0
MINIMAL=0
for arg in "$@"; do
  case "$arg" in
    --force)   FORCE=1 ;;
    --minimal) MINIMAL=1 ;;
    *) echo "알 수 없는 옵션: $arg" >&2; exit 1 ;;
  esac
done

mkdir -p "$BIN_DIR"

# ── 버전 핀 (재현성) ───────────────────────
RG_VERSION="14.1.1"
STARSHIP_VERSION="v1.26.0"
EZA_VERSION="v0.23.5"
BAT_VERSION="v0.26.1"
ZOXIDE_VERSION="v0.10.0"
BTOP_VERSION="v1.4.7"
DELTA_VERSION="0.19.2"
FASTFETCH_VERSION="2.66.0"
DIRENV_VERSION="v2.37.1"
FONT_VERSION="v3.4.0"

# ── 플랫폼 판별 ────────────────────────────
OS="$(uname -s)"
case "$(uname -m)" in
  x86_64 | amd64)  ARCH="x86_64";  FF_ARCH="amd64";   DV_ARCH="amd64" ;;
  aarch64 | arm64) ARCH="aarch64"; FF_ARCH="aarch64"; DV_ARCH="arm64" ;;
  *) echo "지원하지 않는 아키텍처: $(uname -m)" >&2; exit 1 ;;
esac

# rust 타겟 트리플 (starship/eza/bat/zoxide/delta/ripgrep 정적 바이너리 선택용)
target_triple() {
  case "$OS" in
    Linux)
      # x86_64 는 musl 정적(glibc 버전 무관), aarch64 는 gnu
      if [ "$ARCH" = "x86_64" ]; then echo "x86_64-unknown-linux-musl"
      else echo "aarch64-unknown-linux-gnu"; fi ;;
    Darwin) echo "${ARCH}-apple-darwin" ;;
    *) echo "지원하지 않는 OS: $OS" >&2; exit 1 ;;
  esac
}
TRIPLE="$(target_triple)"

# ── 다운로더 (curl 또는 wget) ───────────────
fetch() {  # fetch <url> <출력경로>
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    echo "curl/wget 둘 다 없어서 다운로드 불가" >&2; return 1
  fi
}

# ── 공통: tar.gz 아카이브에서 실행파일 하나 뽑아 설치 ──
# install_tar_bin <바이너리명> <url>
#   아카이브 구조(루트/서브디렉토리)와 무관하게 이름으로 바이너리를 찾아 설치.
install_tar_bin() {
  local bin="$1" url="$2"
  if [ "$FORCE" -eq 0 ] && [ -x "$BIN_DIR/$bin" ]; then
    echo "  $bin 이미 있음: $("$BIN_DIR/$bin" --version 2>/dev/null | head -1)"
    return
  fi
  local tmp; tmp="$(mktemp -d)"
  echo "  $bin 다운로드 중..."
  if fetch "$url" "$tmp/archive.tar.gz" && tar -xzf "$tmp/archive.tar.gz" -C "$tmp" 2>/dev/null; then
    local found
    found="$(find "$tmp" -type f -name "$bin" -perm -u+x 2>/dev/null | head -1)"
    [ -z "$found" ] && found="$(find "$tmp" -type f -name "$bin" 2>/dev/null | head -1)"
    if [ -n "$found" ]; then
      install -m 0755 "$found" "$BIN_DIR/$bin"
      echo "  설치 완료: $BIN_DIR/$bin"
    else
      echo "  ⚠ $bin: 아카이브에서 바이너리를 못 찾음" >&2
    fi
  else
    echo "  ⚠ $bin: 다운로드/해제 실패 ($url)" >&2
  fi
  rm -rf "$tmp"
}

# ── 공통: 단일 raw 바이너리 설치 (direnv) ──
install_raw_bin() {  # <바이너리명> <url>
  local bin="$1" url="$2"
  if [ "$FORCE" -eq 0 ] && [ -x "$BIN_DIR/$bin" ]; then
    echo "  $bin 이미 있음"; return
  fi
  echo "  $bin 다운로드 중..."
  if fetch "$url" "$BIN_DIR/$bin"; then
    chmod 0755 "$BIN_DIR/$bin"; echo "  설치 완료: $BIN_DIR/$bin"
  else
    echo "  ⚠ $bin: 다운로드 실패" >&2; rm -f "$BIN_DIR/$bin"
  fi
}

# ── 공통: git 저장소 클론/갱신 (zsh 플러그인, TPM) ──
install_git_repo() {  # <대상경로> <url>
  local dest="$1" url="$2"
  if ! command -v git >/dev/null 2>&1; then echo "  ⚠ git 없음 — $dest 스킵" >&2; return; fi
  if [ -d "$dest/.git" ]; then
    if [ "$FORCE" -eq 1 ]; then
      git -C "$dest" pull --ff-only -q 2>/dev/null && echo "  갱신: $dest"
    else
      echo "  이미 있음: $dest"
    fi
  else
    mkdir -p "$(dirname "$dest")"
    git clone --depth 1 -q "$url" "$dest" && echo "  클론: $dest"
  fi
}

GH="https://github.com"

echo "no-sudo 바이너리 설치 (대상: $BIN_DIR, triple: $TRIPLE)"
echo ""
echo "바이너리:"

# ── ripgrep ────────────────────────────────
install_tar_bin rg "$GH/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-${TRIPLE}.tar.gz"
# ── starship (프롬프트) ─────────────────────
install_tar_bin starship "$GH/starship/starship/releases/download/${STARSHIP_VERSION}/starship-${TRIPLE}.tar.gz"
# ── eza (ls) ───────────────────────────────
install_tar_bin eza "$GH/eza-community/eza/releases/download/${EZA_VERSION}/eza_${TRIPLE}.tar.gz"
# ── bat (cat) ──────────────────────────────
install_tar_bin bat "$GH/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-${TRIPLE}.tar.gz"
# ── zoxide (cd) ────────────────────────────
install_tar_bin zoxide "$GH/ajeetdsouza/zoxide/releases/download/${ZOXIDE_VERSION}/zoxide-${ZOXIDE_VERSION#v}-${TRIPLE}.tar.gz"
# ── btop (top) ─────────────────────────────  (항상 musl)
install_tar_bin btop "$GH/aristocratos/btop/releases/download/${BTOP_VERSION}/btop-${ARCH}-unknown-linux-musl.tar.gz"
# ── delta (git diff) ───────────────────────
install_tar_bin delta "$GH/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${TRIPLE}.tar.gz"
# ── fastfetch ──────────────────────────────
install_tar_bin fastfetch "$GH/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-${FF_ARCH}.tar.gz"
# ── direnv (raw 바이너리) ──────────────────
install_raw_bin direnv "$GH/direnv/direnv/releases/download/${DIRENV_VERSION}/direnv.linux-${DV_ARCH}"

# ── zsh 플러그인 (매니저 없이 source) + TPM ──
echo ""
echo "zsh 플러그인 · tmux TPM:"
ZSH_PLUGIN_DIR="${HOME}/.local/share/zsh/plugins"
install_git_repo "$ZSH_PLUGIN_DIR/zsh-autosuggestions"     "$GH/zsh-users/zsh-autosuggestions"
install_git_repo "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" "$GH/zsh-users/zsh-syntax-highlighting"
install_git_repo "${HOME}/.tmux/plugins/tpm"               "$GH/tmux-plugins/tpm"

# ── JetBrainsMono Nerd Font (클라이언트 전용) ──
install_font() {
  if [ "$MINIMAL" -eq 1 ]; then echo "  (--minimal: 폰트 스킵)"; return; fi
  local dir="${HOME}/.local/share/fonts/JetBrainsMonoNF"
  if [ "$FORCE" -eq 0 ] && ls "$dir"/*.ttf >/dev/null 2>&1; then
    echo "  JetBrainsMono NF 이미 있음: $dir"; return
  fi
  if ! command -v unzip >/dev/null 2>&1; then
    echo "  ⚠ unzip 없음 — 폰트 스킵 (sudo apt install unzip)" >&2; return
  fi
  local tmp; tmp="$(mktemp -d)"
  echo "  JetBrainsMono Nerd Font 다운로드 중..."
  if fetch "$GH/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/JetBrainsMono.zip" "$tmp/font.zip"; then
    mkdir -p "$dir"
    unzip -oq "$tmp/font.zip" -d "$dir"
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$dir" >/dev/null 2>&1
    echo "  설치 완료: $dir"
  else
    echo "  ⚠ 폰트 다운로드 실패" >&2
  fi
  rm -rf "$tmp"
}
echo ""
echo "폰트:"
install_font

# ── bat 테마 캐시 (심링크된 tokyonight tmTheme 반영) ──
# install.sh 로 ~/.config/bat 심링크 후 실행되면 커스텀 테마가 잡힙니다.
if [ -x "$BIN_DIR/bat" ] && [ -d "${HOME}/.config/bat/themes" ]; then
  echo ""
  echo "bat 테마 캐시 빌드:"
  "$BIN_DIR/bat" cache --build >/dev/null 2>&1 && echo "  완료" || echo "  (스킵 — install.sh 후 'bat cache --build' 재시도)"
fi

# ── PATH 확인 ──────────────────────────────
case ":${PATH}:" in
  *":${BIN_DIR}:"*) ;;
  *) echo ""
     echo "  ⚠ $BIN_DIR 가 PATH에 없습니다. 셸 설정에 추가하세요:"
     echo '      export PATH="$HOME/.local/bin:$PATH"' ;;
esac

echo ""
echo "완료.  (셸: sudo apt install zsh wl-clipboard  후  chsh -s \$(command -v zsh))"
