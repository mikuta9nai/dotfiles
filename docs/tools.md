# tools/install-bins.sh

정적 바이너리를 **sudo 없이** `~/.local/bin` 에 설치합니다.
패키지 매니저도 관리자 권한도 필요 없어서, 권한이 없는 공용 머신이나 낯선 SSH
박스에서도 동일하게 동작합니다.

> 이 스크립트는 **선택**입니다. 설정은 도구가 없어도 폴백으로 동작하므로
> (예: telescope grep 은 `rg` 가 없으면 시스템 `grep` 사용) 안 깔아도 깨지지
> 않고, "있으면 더 빠르고 예쁜" 업그레이드 용도입니다.

## 사용법

```bash
./tools/install-bins.sh           # 빠진 것만 설치
./tools/install-bins.sh --force   # 이미 있어도 다시 받기
./tools/install-bins.sh --minimal # 폰트 스킵 (헤드리스/서버)
```

`~/.local/bin` 이 PATH 에 없으면 셸 설정에 추가하세요:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 설치 대상

### 바이너리 (`~/.local/bin`)

| 도구 | 대체 | 쓰이는 곳 |
|---|---|---|
| ripgrep `rg` | grep | telescope 검색 가속 (`<leader>ps`, `<leader>pg`) |
| starship | 프롬프트 | `zsh/.zshrc` (L4) |
| eza | ls | `ls` alias (L4) |
| bat | cat | `cat` alias · man 페이지 색상 (L5) |
| zoxide | cd | `z` 점프 (L4) |
| btop | top | (L5) |
| delta | git diff | `git/.gitconfig` 의 pager (L5) |
| fastfetch | neofetch | 로그인 셸 1회 출력 (L5) |
| direnv | — | 폴더별 `.envrc` 자동 로드 (L5) |

버전은 스크립트 상단에 핀으로 고정돼 있습니다(재현성). 새 버전이 필요하면
`*_VERSION` 값만 바꾸고 `--force` 로 다시 받으세요.

### 바이너리가 아닌 것

| 항목 | 위치 | 용도 |
|---|---|---|
| zsh-autosuggestions | `~/.local/share/zsh/plugins/` | 히스토리 기반 제안 (매니저 없이 `source`) |
| zsh-syntax-highlighting | `~/.local/share/zsh/plugins/` | 명령 하이라이팅 |
| TPM | `~/.tmux/plugins/tpm` | tmux 플러그인 매니저 (세션 영속) |
| JetBrainsMono Nerd Font | `~/.local/share/fonts/` | L1. `--minimal` 이면 스킵 |

폰트는 **클라이언트 전용**(앉아서 쓰는 머신)입니다. 헤드리스 서버에서는
`--minimal` 로 건너뛰세요. `unzip` 이 없으면 경고만 남기고 넘어갑니다.

## 이 스크립트가 다루지 않는 것

정적 배포가 마땅치 않아 패키지 매니저가 필요한 것들입니다:

```bash
sudo apt install zsh wl-clipboard   # 셸 본체 · Wayland 클립보드
```

`claude` CLI(nvim 의 claudecode 연동용)도 여기서 다루지 않습니다.
없으면 `<leader>c*` 키가 동작하지 않을 뿐, 나머지 설정에는 영향이 없습니다.

## 동작 방식

OS 와 아키텍처를 감지해 Rust 타깃 트리플(`x86_64-unknown-linux-musl`,
`aarch64-unknown-linux-gnu`, `<arch>-apple-darwin`)을 만들고 GitHub 릴리스에서
받습니다. 다운로드는 `curl` 을 먼저 시도하고 없으면 `wget` 으로 폴백합니다.
btop 은 항상 musl 빌드, fastfetch·direnv 는 자체 아키텍처 표기를 씁니다.

각 설치 함수는 **이미 있으면 건너뛰고 `--force` 일 때만 다시 받습니다.**
개별 다운로드가 실패해도 경고만 남기고 나머지를 계속 설치합니다
(`set -uo pipefail` — `-e` 는 일부러 뺐습니다).

마지막에 `~/.config/bat/themes` 가 링크돼 있으면 `bat cache --build` 로
tokyonight 테마를 반영합니다. `install.sh` 를 먼저 돌린 뒤 실행하면 자동으로 잡힙니다.

## 항목 추가하기

`install_tar_bin <바이너리명> <url>` 또는 `install_raw_bin <바이너리명> <url>`
한 줄을 호출부에 추가하고, 버전은 상단 핀 블록에 올리세요. git 저장소로 받는
것(zsh 플러그인 등)은 `install_git_repo <대상경로> <url>` 을 씁니다.
