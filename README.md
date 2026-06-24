# dotfiles

Linux / macOS / Windows 공용 개인 설정 모음.

## 구조

```
dotfiles/
├── install.sh      # Linux / macOS 설치 (심볼릭 링크)
├── install.ps1     # Windows 설치 (심볼릭 링크)
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

## tmux

- prefix: `C-a` (기본 `C-b` 에서 변경)
- `C-a |` / `C-a -` : 수직/수평 분할
- `C-a h/j/k/l` : Vi 스타일 패인 이동
- `C-a H/J/K/L` : 패인 크기 조절 (반복 가능)
- `C-a Enter` : 복사 모드 진입 → `v` 선택, `y` 복사
- `C-a r` : 설정 리로드
- 마우스 지원 활성화, 상태바 Catppuccin Mocha 스타일

## Neovim

- 플러그인 매니저: [lazy.nvim](https://github.com/folke/lazy.nvim)
- 첫 실행 시 플러그인이 자동 설치됩니다.
- LSP 서버는 `:Mason` 으로 관리. Treesitter 파서는 자동 설치.
- Python LSP 는 npm 없이 동작하도록 `jedi-language-server`(pip) 사용.

## 새 항목 추가하기

1. dotfiles 안에 설정 폴더/파일을 둔다 (예: `zsh/.zshrc`).
2. `install.sh` 와 `install.ps1` 의 링크 매핑 블록에 `link` 호출을 추가한다.
