# dotfiles

Neovim · tmux · 셸 · 터미널 개인 설정. Linux / macOS / Windows 공용.
클론 후 스크립트 하나만 실행하면 설정이 각 OS의 제자리로 심볼릭 링크됩니다.

터미널은 **레이어**로 구성됩니다 — 폰트(L1) · 터미널 에뮬레이터(L2) ·
멀티플렉서(L3) · 셸(L4) · CLI 도구(L5). 전체가 **Tokyo Night (Storm)** 팔레트로 통일.
L1·L2 는 "앉아서 쓰는 클라이언트", L3·L4·L5 는 "명령이 실제로 도는 서버"에 필요합니다.

## 구성 요소

| 레이어 | 영역 | 위치 | 링크 대상 |
|---|---|---|---|
| L1 | JetBrainsMono Nerd Font | — | `tools/install-bins.sh` 가 설치 (클라이언트) |
| L2 | Ghostty | `ghostty/config` | `~/.config/ghostty/config` (클라이언트) |
| L3 | tmux | `tmux/.tmux.conf` | `~/.tmux.conf` |
| L4 | zsh | `zsh/.zshrc` · `zsh/.zshenv` | `~/.zshrc` · `~/.zshenv` |
| L4 | Starship 프롬프트 | `starship/starship.toml` | `~/.config/starship.toml` |
| L5 | bat · btop · fastfetch | `bat/` `btop/` `fastfetch/` | `~/.config/` 아래 각각 |
| L5 | git (+ delta pager) | `git/.gitconfig` | `~/.gitconfig` |
| — | Neovim | `nvim/` | `~/.config/nvim` (Win: `%LOCALAPPDATA%\nvim`) |
| — | 설치 | `install.sh` · `install.ps1` | 심링크 + 기존 파일 자동 백업 |
| — | 선택 도구 | `tools/install-bins.sh` | `~/.local/bin` (sudo 불필요) |
| — | 문서 | `docs/` | 아래 인덱스 |

Neovim 은 레이어 밖입니다. 터미널 안에서 돌지만 어느 레이어에도 의존하지 않고,
`nvim/` 만 링크해도 그대로 동작합니다.

## 설계 원칙

왜 이렇게 나뉘어 있는지.

1. **아무것도 설치돼 있지 않아도 동작한다.**
   telescope grep 은 `rg` 가 있으면 쓰고 없으면 시스템 `grep` 으로 폴백합니다.
   Python LSP 는 npm(Node) 이 필요 없는 `jedi-language-server` 를 씁니다.
   zsh 설정도 eza·bat·zoxide 가 없으면 `command -v` 로 알아서 비켜갑니다.
   sudo 도 패키지 매니저도 없는 낯선 SSH 박스가 기준선입니다.

2. **설치 스크립트는 링크만 한다. 패키지는 설치하지 않는다.**
   그래서 바이너리 설치는 `tools/` 의 별도 스크립트로 분리돼 있고, 그건 **선택**입니다.
   설치 단계에서 실패할 여지를 없애려는 의도입니다.

3. **OS 별로 스크립트만 나누고 설정 본문은 공유한다.**
   `install.sh` 와 `install.ps1` 은 링크 매핑만 다르고, `nvim/` 은 세 OS 가 그대로 씁니다.

4. **키맵의 정답은 한 곳에만 둔다.**
   [docs/keymaps.md](docs/keymaps.md) 하나뿐입니다. 다른 문서는 여기로 보내기만 합니다.

5. **클라이언트에만 필요한 것과 어디서나 필요한 것을 나눈다.**
   폰트·터미널 에뮬레이터(L1·L2)는 화면이 있는 머신에만 의미가 있습니다.
   헤드리스 서버에서는 `--minimal` 로 건너뜁니다. 레이어 구분은 이 결정을
   위한 것이지 분류를 위한 것이 아닙니다.

## 설치

### Linux / macOS

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

./install.sh                       # 설정 심볼릭 링크 (헤드리스면 ./install.sh --minimal)
./tools/install-bins.sh            # 선택: no-sudo 도구·폰트 (서버면 --minimal 로 폰트 스킵)

sudo apt install zsh wl-clipboard  # 셸 본체 + Wayland 클립보드 (정적배포가 없어 apt)
chsh -s "$(command -v zsh)"        # 기본 셸을 zsh 로 (재로그인 후 적용)
```

기존 파일이 있으면 `.bak.<timestamp>` 로 백업한 뒤 링크합니다.
이미 심링크면 그냥 교체합니다.

### Windows (PowerShell)

```powershell
git clone <repo-url> $HOME\dotfiles
cd $HOME\dotfiles
# 심볼릭 링크 생성에 관리자 권한 또는 개발자 모드 필요
.\install.ps1
```

Windows 는 `nvim/` 만 링크합니다 (tmux·zsh 는 대상 아님).

## 레이어별 메모

- **Ghostty (L2)** — `theme = TokyoNight Storm`, JetBrainsMono NF, 은은한 투명(0.95)+블러.
  확장자 없는 `~/.config/ghostty/config` 만 읽습니다(`config.ghostty` 오타 주의).
- **tmux (L3)** — prefix `C-Space`, `C-h/j/k/l` 로 nvim split ↔ tmux pane 심리스 이동.
  **세션 영속**(TPM + resurrect/continuum): 재부팅해도 세션·창·패인 복원.
  첫 설치 후 tmux 안에서 `prefix + I` 로 플러그인을 받아야 둘 다 작동합니다.
  복사(`y`)는 시스템 클립보드(Wayland `wl-copy`, SSH 는 OSC52)로.
- **zsh + Starship (L4)** — 히스토리(공유·중복제거) · `AUTO_CD` · 대소문자 무시 완성 ·
  fzf 키바인딩(`C-r`/`C-t`/`M-c`) · `ls→eza`·`cat→bat` alias · bat 색상 man 페이지.
  프롬프트는 두 줄 powerline. **bash(`.bashrc`)는 폴백으로 보존** — 낯선 서버·스크립트용.
- **CLI 도구 (L5)** — bat(cat) · btop(top) · delta(git diff) · fastfetch · direnv.
  전부 `tools/install-bins.sh` 로 `~/.local/bin` 에. 없어도 설정은 깨지지 않습니다.
- **Neovim** — [lazy.nvim](https://github.com/folke/lazy.nvim), 첫 실행 시 자동 설치.
  테마 Tokyo Night(storm). LSP 는 `:Mason`. 키맵 ThePrimeagen 스타일.
  Claude Code 연동은 `claude` CLI 가 PATH 에 있을 때만 동작합니다.

## 문서

| 문서 | 내용 |
|---|---|
| [docs/keymaps.md](docs/keymaps.md) | 전체 키 바인딩 치트시트 (tmux + nvim) |
| [docs/neovim.md](docs/neovim.md) | nvim 설정 내부 구조 — 어떤 파일이 무엇을 담당하나 |
| [docs/tools.md](docs/tools.md) | `install-bins.sh` 상세 — 설치 목록·플래그·항목 추가법 |
| [docs/rollback.md](docs/rollback.md) | 안전망과 되돌리기 — 실험 워크플로·태그·Brewfile |
| [docs/roadmap.md](docs/roadmap.md) | 맥 개발 환경 구축 로드맵 (진행 중) |

## 새 항목 추가하기

1. 설정 폴더/파일을 저장소 안에 둔다 (예: `zsh/.zshrc`).
2. `install.sh` 와 `install.ps1` 의 링크 매핑 블록에 `link` 호출을 추가한다.
   클라이언트 전용(폰트·에뮬레이터)이면 `--minimal` 스킵 블록에 넣는다.
3. 새 no-sudo 도구는 `tools/install-bins.sh` 에 `install_tar_bin`/`install_raw_bin`
   한 줄로 추가하고 [docs/tools.md](docs/tools.md) 표를 갱신한다.
4. nvim 플러그인이라면 `nvim/lua/plugins/<이름>.lua` 를 만든 뒤
   **`nvim/lua/plugins/init.lua` 의 import 목록에도 등록한다.**
   자동 탐색이 아니라서 파일만 추가하면 로드되지 않는다.
5. 키맵을 바꿨으면 [docs/keymaps.md](docs/keymaps.md) 를 갱신한다.
