# dotfiles

Linux / macOS / Windows 공용 개인 설정 모음.

터미널은 **레이어**로 구성됩니다 — 폰트(L1) · 터미널 에뮬레이터 Ghostty(L2) ·
멀티플렉서 tmux(L3) · 셸 zsh+Starship(L4) · CLI 도구(L5). 전체 **Tokyo Night (Storm)**
팔레트로 통일. L1·L2 는 "앉아서 쓰는 클라이언트", L3·L4·L5 는 "명령이 도는 서버"에 필요.

## 구조

```
dotfiles/
├── install.sh           # Linux / macOS 설치 (심볼릭 링크)  [--minimal: ghostty 제외]
├── install.ps1          # Windows 설치 (심볼릭 링크)
├── docs/keymaps.md      # 전체 키맵 치트시트
├── tools/
│   └── install-bins.sh  # no-sudo 바이너리 설치 (starship·eza·bat·… → ~/.local/bin)
├── ghostty/config       # L2  터미널 에뮬레이터 (Tokyo Night Storm)   ── 클라이언트
├── zsh/
│   ├── .zshrc           # L4  대화형 셸 (플러그인·alias·fzf·history)
│   └── .zshenv          # L4  환경/PATH (모든 zsh)
├── starship/starship.toml # L4  프롬프트 (두 줄 powerline, Tokyo Night)
├── bat/                 # L5  cat 대체 (config + tokyonight tmTheme)
├── btop/                # L5  top 대체 (btop.conf + tokyonight theme)
├── fastfetch/config.jsonc # L5  시스템 정보 (로그인 셸 1회)
├── git/.gitconfig       # L5  delta(git diff) + 기본값
├── tmux/.tmux.conf      # L3  Tokyo Night 상태바 + TPM 세션영속 + 클립보드
└── nvim/                # Neovim (lazy.nvim, Tokyo Night)
```

## 설치

### Linux / macOS

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

./install.sh                       # 설정 심볼릭 링크 (헤드리스면 ./install.sh --minimal)
./tools/install-bins.sh            # no-sudo 도구·폰트·플러그인 (서버면 --minimal 로 폰트 스킵)

sudo apt install zsh wl-clipboard  # 셸 + Wayland 클립보드 (정적배포 없어 apt)
chsh -s "$(command -v zsh)"        # 기본 셸을 zsh 로 (재로그인 후 적용)
```

설치 스크립트는 각 설정을 OS/XDG 위치로 심볼릭 링크하고, 기존 파일은
`.bak.<timestamp>` 로 백업합니다.

### Windows (PowerShell)

```powershell
git clone <repo-url> $HOME\dotfiles
cd $HOME\dotfiles
.\install.ps1                       # 관리자 권한 또는 개발자 모드 필요 (심볼릭 링크)
```

전체 키 바인딩은 **[docs/keymaps.md](docs/keymaps.md) 치트시트**에 정리돼 있습니다.

## 도구 설치 (tools/install-bins.sh)

`~/.local/bin` 에 **sudo 없이** 정적 바이너리를 받습니다. 42 클러스터·개인 머신·SSH 박스
어디서나 동일. 설치 목록:

| 도구 | 대체 | 도구 | 대체 |
|---|---|---|---|
| ripgrep `rg` | grep | zoxide `z` | cd |
| starship | 프롬프트 | btop | top |
| eza | ls | delta | git diff |
| bat | cat | fastfetch | neofetch |
| fd (기존) | find | direnv | 프로젝트 환경 |

+ zsh 플러그인(autosuggestions·syntax-highlighting), tmux TPM, JetBrainsMono Nerd Font.

```bash
./tools/install-bins.sh            # 빠진 것만
./tools/install-bins.sh --force    # 이미 있어도 다시
./tools/install-bins.sh --minimal  # 폰트 스킵 (헤드리스)
```

> **선택**입니다. 설정(nvim·zsh 등)은 도구가 없어도 `command -v` 폴백으로 동작하므로,
> 안 깔아도 깨지지 않고 "있으면 더 예쁘고 빠른" 업그레이드입니다.
> `~/.local/bin` 이 PATH 에 없으면: `export PATH="$HOME/.local/bin:$PATH"`

## 셸 (zsh + Starship)

- **zsh**: 히스토리(공유·중복제거) · `AUTO_CD` · 대소문자 무시 완성 · fzf 키바인딩
  (`Ctrl+R`/`Ctrl+T`/`Alt+C`) · `ls→eza`·`cat→bat` alias · bat 색상 man 페이지.
  하이라이팅/자동완성은 zsh 플러그인. **bash(`.bashrc`)는 폴백으로 보존** — 낯선 서버·스크립트용.
- **Starship**: 두 줄 powerline 프롬프트, Tokyo Night. git·경로·언어버전·소요시간 표시.
- **direnv**: 폴더 진입 시 `.envrc` 자동 로드(uv·venv).

## 터미널 (Ghostty)

- `theme = TokyoNight Storm`, JetBrainsMono NF, 은은한 투명(0.95)+블러.
- Ghostty 는 확장자 없는 `~/.config/ghostty/config` 만 읽습니다(기존 `config.ghostty` 오타 주의).

## tmux

- prefix `C-Space`, `C-h/j/k/l` 로 nvim split ↔ tmux pane 심리스 이동(vim-tmux-navigator), **Tokyo Night** 상태바.
- **세션 영속**(TPM + resurrect/continuum): 재부팅해도 세션·창·패인 복원. 첫 설치 후 `prefix + I`.
- 복사(`y`)는 시스템 클립보드(Wayland `wl-copy`, SSH 는 OSC52)로.
- 키 전체: [docs/keymaps.md](docs/keymaps.md#tmux--tmuxconf)

## Neovim

- 플러그인: [lazy.nvim](https://github.com/folke/lazy.nvim), 첫 실행 시 자동 설치. 테마 Tokyo Night(storm).
- LSP 는 `:Mason`. Python LSP 는 `jedi-language-server`(pip). 키맵 ThePrimeagen 스타일.
- 전체: [docs/keymaps.md](docs/keymaps.md#neovim)

## 새 항목 추가하기

1. dotfiles 안에 설정 폴더/파일을 둔다.
2. `install.sh`(그리고 `install.ps1`)의 `link` 매핑 블록에 호출을 추가한다.
   클라이언트 전용(폰트·에뮬레이터)은 `--minimal` 스킵 블록에 넣는다.
3. 새 no-sudo 도구는 `tools/install-bins.sh` 에 `install_tar_bin`/`install_raw_bin` 한 줄로.
4. 키맵을 바꿨으면 [docs/keymaps.md](docs/keymaps.md) 갱신.
