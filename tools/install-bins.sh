#!/usr/bin/env bash
# ==========================================
# no-sudo 사용자 로컬 바이너리 설치기
# ==========================================
# 정적 바이너리를 ~/.local/bin 에 받습니다. sudo / 패키지매니저 불필요.
# 42 클러스터(sudo 없음) · 개인 머신 · 낯선 SSH 박스 어디서나 동일하게 동작.
#
# 사용법:  ./tools/install-bins.sh           # 빠진 것만 설치
#          ./tools/install-bins.sh --force   # 이미 있어도 다시 받기
#
# config(nvim 등)는 이 바이너리가 없어도 폴백으로 동작하므로, 이 스크립트는
# "필수"가 아니라 "검색을 더 빠르게 하는 선택적 업그레이드" 입니다.

set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

mkdir -p "$BIN_DIR"

# ── 플랫폼 판별 ────────────────────────────
OS="$(uname -s)"
case "$(uname -m)" in
  x86_64 | amd64)  ARCH="x86_64" ;;
  aarch64 | arm64) ARCH="aarch64" ;;
  *) echo "지원하지 않는 아키텍처: $(uname -m)" >&2; exit 1 ;;
esac

# rust 타겟 트리플 (정적 바이너리 선택용)
target_triple() {
  case "$OS" in
    Linux)
      # x86_64 는 musl 정적(글ibc 버전 무관), aarch64 는 gnu
      if [ "$ARCH" = "x86_64" ]; then echo "x86_64-unknown-linux-musl"
      else echo "aarch64-unknown-linux-gnu"; fi ;;
    Darwin) echo "${ARCH}-apple-darwin" ;;
    *) echo "지원하지 않는 OS: $OS" >&2; exit 1 ;;
  esac
}

# ── 다운로더 (curl 또는 wget) ───────────────
fetch() {  # fetch <url> <출력경로>
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    echo "curl/wget 둘 다 없어서 다운로드 불가" >&2; exit 1
  fi
}

# ── ripgrep ────────────────────────────────
RG_VERSION="14.1.1"
install_ripgrep() {
  if [ "$FORCE" -eq 0 ] && [ -x "$BIN_DIR/rg" ]; then
    echo "  rg 이미 있음: $BIN_DIR/rg ($("$BIN_DIR/rg" --version | head -1))"
    return
  fi
  local triple base url tmp
  triple="$(target_triple)"
  base="ripgrep-${RG_VERSION}-${triple}"
  url="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/${base}.tar.gz"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN

  echo "  ripgrep ${RG_VERSION} 다운로드 중 (${triple})..."
  fetch "$url" "$tmp/rg.tar.gz"
  tar -xzf "$tmp/rg.tar.gz" -C "$tmp"
  install -m 0755 "$tmp/${base}/rg" "$BIN_DIR/rg"
  echo "  설치 완료: $BIN_DIR/rg"
}

echo "no-sudo 바이너리 설치 (대상: $BIN_DIR)"
install_ripgrep
# Step 3 에서 fzf 추가 예정:
# install_fzf

# ── PATH 확인 ──────────────────────────────
case ":${PATH}:" in
  *":${BIN_DIR}:"*) ;;
  *) echo ""
     echo "  ⚠ $BIN_DIR 가 PATH에 없습니다. 셸 설정에 추가하세요:"
     echo '      export PATH="$HOME/.local/bin:$PATH"' ;;
esac

echo "완료."
