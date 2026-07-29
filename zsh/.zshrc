# ~/.zshrc — 대화형 zsh 설정
# (PATH·환경은 ~/.zshenv 에서. 이 파일은 대화형 셸에서만 로드됨)
# 도구가 없어도 깨지지 않도록 전부 `command -v` 가드. bash 는 폴백으로 보존.

# ─── 히스토리 ──────────────────────────────────────────────────────────────────
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY

# ─── zsh 옵션 ──────────────────────────────────────────────────────────────────
setopt AUTO_CD                 # 디렉토리명만 쳐도 이동
setopt INTERACTIVE_COMMENTS    # 대화형에서 # 주석 허용
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt NO_BEEP

# ─── 자동완성 ──────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'      # 대소문자 무시
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"        # 파일색과 일치
zstyle ':completion:*' group-name ''

bindkey -e   # emacs 키 (Ctrl+A/E/R 등)

# ─── 플러그인 로더 ─────────────────────────────────────────────────────────────
# 설치 위치가 환경마다 다릅니다. install-bins.sh 는 ~/.local/share/zsh/plugins 에,
# 맥 brew 는 /opt/homebrew/share 에 둡니다. 레이아웃은 <루트>/<이름>/<이름>.zsh 로
# 양쪽이 같으므로 먼저 찾은 쪽을 씁니다. 어디에도 없으면 조용히 넘어갑니다.
zsh_plugin() {
  local root
  for root in "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins" /opt/homebrew/share; do
    if [ -f "$root/$1/$1.zsh" ]; then
      source "$root/$1/$1.zsh"
      return
    fi
  done
}

zsh_plugin zsh-autosuggestions   # 이전에 친 명령을 회색으로 미리 보여줌

# ─── 도구 init ─────────────────────────────────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v mise     >/dev/null && eval "$(mise activate zsh)"   # 런타임 버전 관리

# fzf 키바인딩/완성 (Ctrl+R 히스토리, Ctrl+T 파일, Alt+C cd)
if command -v fzf >/dev/null; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)                                        # fzf ≥ 0.48
  else                                                         # 구버전 폴백
    for f in /usr/share/doc/fzf/examples/{key-bindings,completion}.zsh; do
      [ -f "$f" ] && source "$f"
    done
  fi
fi

# ─── fzf 색 (Tokyo Night Storm) + fd 연동 ───────────────────────────────────────
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none \
--color=bg+:#2e3c64 --color=bg:#1f2335 --color=border:#29a4bd --color=fg:#c0caf5 \
--color=gutter:#1f2335 --color=header:#ff9e64 --color=hl+:#2ac3de --color=hl:#2ac3de \
--color=info:#545c7e --color=marker:#ff007c --color=pointer:#ff007c --color=prompt:#2ac3de \
--color=query:#c0caf5:regular --color=scrollbar:#29a4bd --color=separator:#ff9e64 --color=spinner:#ff007c"
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# ─── alias (기본 명령 덮어쓰기) ────────────────────────────────────────────────
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --git'
  alias la='eza -a  --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
fi
command -v bat >/dev/null && alias cat='bat'
# cd 는 원본 유지 (점프는 zoxide 의 z 사용)

# ─── man 페이지 색 (bat) ───────────────────────────────────────────────────────
if command -v bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# ─── fastfetch: 로그인 셸 & tmux 밖에서만 (새 터미널 1회) ────────────────────────
if [[ -o login ]] && [[ -z "$TMUX" ]] && command -v fastfetch >/dev/null; then
  fastfetch
fi

# ─── syntax-highlighting: 반드시 마지막에 source ───────────────────────────────
zsh_plugin zsh-syntax-highlighting   # 명령어가 맞으면 초록, 틀리면 빨강
