# ~/.zshenv — 모든 zsh 인스턴스(로그인/대화형/스크립트)에서 로드.
# PATH 등 "환경"만 여기에. 대화형 꾸미기는 ~/.zshrc 로.

# no-sudo 로컬 바이너리 (~/.local/bin) 우선
export PATH="$HOME/.local/bin:$PATH"

# uv / astral 도구 환경 (POSIX env 파일 — PATH prepend 는 내부에서 중복 가드됨)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
