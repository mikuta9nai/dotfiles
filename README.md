# dotfiles

Linux / macOS / Windows 공용 개인 설정 모음.

## 구조

```
dotfiles/
├── install.sh      # Linux / macOS 설치 (심볼릭 링크)
├── install.ps1     # Windows 설치 (심볼릭 링크)
├── docs/
│   └── keymaps.md       # 전체 키맵 치트시트
├── tools/
│   └── install-bins.sh  # no-sudo 바이너리 설치 (rg 등 → ~/.local/bin)
├── tmux/
│   └── .tmux.conf  # tmux 설정 (→ ~/.tmux.conf)
└── nvim/           # Neovim 설정 (→ ~/.config/nvim)
    ├── init.lua
    └── lua/
        ├── options.lua      # 기본 옵션
        ├── keymaps.lua      # 키 바인딩
        ├── autocmds.lua     # autocommand
        └── plugins/         # lazy.nvim 플러그인 스펙
            ├── lsp.lua          # LSP + 자동완성 (clangd/jedi/rust_analyzer/lua_ls)
            ├── treesitter.lua   # 구문 하이라이팅
            ├── format.lua       # conform 포매터
            ├── telescope.lua    # 파일 탐색
            ├── ui.lua           # 테마
            ├── harpoon.lua / undotree.lua / header.lua
```

## 설치

### Linux / macOS

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Windows (PowerShell)

```powershell
git clone <repo-url> $HOME\dotfiles
cd $HOME\dotfiles
# 관리자 권한 또는 개발자 모드 필요 (심볼릭 링크)
.\install.ps1
```

설치 스크립트는 각 설정을 OS에 맞는 위치로 심볼릭 링크합니다.
기존 파일이 있으면 `.bak.<timestamp>` 로 백업합니다.

전체 키 바인딩은 **[docs/keymaps.md](docs/keymaps.md) 치트시트**에 정리돼 있습니다.

## 도구 설치 (tools/install-bins.sh)

검색 속도를 높이는 `ripgrep` 같은 도구를 **sudo 없이** `~/.local/bin` 에 정적
바이너리로 설치합니다. 42 클러스터(sudo 불가)·개인 머신·SSH 박스 어디서나 동일하게 동작.

```bash
./tools/install-bins.sh           # 빠진 것만 설치
./tools/install-bins.sh --force   # 이미 있어도 다시 받기
```

> 이 스크립트는 **선택**입니다. 설정(nvim 등)은 도구가 없어도 폴백으로 동작하므로,
> 안 깔아도 깨지지 않고 "있으면 더 빠른" 업그레이드 용도입니다.
> (예: telescope grep 은 `rg` 없으면 시스템 `grep` 으로 자동 폴백)

`~/.local/bin` 이 PATH 에 없으면 셸 설정에 추가하세요:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## tmux

- prefix 를 `C-a` 로 변경, Vi 스타일 패인 이동/분할, Catppuccin Mocha 상태바.
- 키 전체: [docs/keymaps.md](docs/keymaps.md#tmux--tmuxconf)

## Neovim

- 플러그인 매니저: [lazy.nvim](https://github.com/folke/lazy.nvim). 첫 실행 시 자동 설치.
- LSP 서버는 `:Mason` 으로 관리. Treesitter 파서는 자동 설치.
- Python LSP 는 npm 없이 동작하도록 `jedi-language-server`(pip) 사용.
- 키맵은 ThePrimeagen 스타일(harpoon 파일 점프 + telescope + LSP).
  전체: [docs/keymaps.md](docs/keymaps.md#neovim)

## 새 항목 추가하기

1. dotfiles 안에 설정 폴더/파일을 둔다 (예: `zsh/.zshrc`).
2. `install.sh` 와 `install.ps1` 의 링크 매핑 블록에 `link` 호출을 추가한다.
3. 키맵을 바꿨으면 [docs/keymaps.md](docs/keymaps.md) 도 갱신한다.
