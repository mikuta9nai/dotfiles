# ~/.zshenv — 모든 zsh 인스턴스(로그인/대화형/스크립트)에서 로드.
# PATH 등 "환경"만 여기에. 대화형 꾸미기는 ~/.zshrc 로.

typeset -U path        # PATH 중복 제거 (중첩 셸에서 같은 항목이 쌓이는 것 방지)

# no-sudo 로컬 바이너리 (~/.local/bin) 우선
export PATH="$HOME/.local/bin:$PATH"

# uv / astral 도구 환경 (POSIX env 파일 — PATH prepend 는 내부에서 중복 가드됨)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ─── 자기 폴더에 설치되는 도구들 (있을 때만) ───────────────────────────────────
# 표준 bin 경로 밖에 깔리는 것들. 없는 머신에서는 조용히 넘어갑니다.
# Homebrew 자체의 PATH 는 맥의 ~/.zprofile 이 담당하므로 여기서 다루지 않습니다.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"                    # cargo · rustc
[ -d "$HOME/.duckdb/cli/latest" ] && path=("$HOME/.duckdb/cli/latest" $path)

# VS Code 의 code 명령 (맥)
[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ] \
  && path+=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin")
