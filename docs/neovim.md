# Neovim 설정 구조

`nvim/` → `~/.config/nvim` (Windows: `%LOCALAPPDATA%\nvim`) 로 링크됩니다.
키 바인딩은 [keymaps.md](keymaps.md), 저장소 전체 개요는 [README](../README.md).

**전제:** Neovim 0.11+ (`lsp.lua` 가 `vim.lsp.config()` 신 API 를 씁니다),
mason-lspconfig 2.x.

## 파일 배치

```
nvim/
├── init.lua              # 진입점. 아래 4개를 순서대로 require
├── lazy-lock.json        # 플러그인 커밋 고정
└── lua/
    ├── options.lua       # vim 옵션 (leader, 줄번호, 들여쓰기, 클립보드)
    ├── keymaps.lua       # 플러그인과 무관한 키맵
    ├── autocmds.lua      # 줄 끝 공백 제거, yank 하이라이트, SmartRoot
    └── plugins/
        ├── init.lua      # lazy.nvim 부트스트랩 + import 목록
        ├── lsp.lua       # LSP + 자동완성 (clangd/jedi/rust_analyzer/lua_ls)
        ├── treesitter.lua# 구문 하이라이팅 + 자동 들여쓰기
        ├── format.lua    # conform 포매터
        ├── telescope.lua # 파일·문자열 검색
        ├── ui.lua        # 테마 (tokyonight)
        ├── harpoon.lua   # 파일 즐겨찾기 점프
        ├── undotree.lua  # 되돌리기 트리
        ├── tmux-navigator.lua # split ↔ tmux pane 심리스 이동
        └── claudecode.lua# Claude Code 연동
```

## 왜 이렇게 나뉘어 있나

**로드 순서가 중요하다.** `init.lua` 는 `options → keymaps → autocmds → plugins`
순으로 require 합니다. `options` 가 맨 앞인 이유는 lazy.nvim 이 `mapleader` 를
읽은 뒤 플러그인 키맵을 등록하기 때문입니다. 순서를 바꾸면 leader 키가 안 먹습니다.

**`lua/` 3개 파일은 플러그인이 하나도 없어도 동작한다.** 플러그인 설치가 실패하거나
네트워크가 없는 환경에서도 기본 편집 환경은 그대로 뜹니다.

**`lua/plugins/*.lua` 는 파일 1개 = 관심사 1개다** — 플러그인 1개가 아닙니다.
`lsp.lua` 에는 mason·lspconfig·cmp 등 스펙 여러 개가 함께 들어 있고,
`telescope.lua` 에는 telescope 와 fzf-native 가 같이 있습니다. 같이 고칠 것들을
같은 파일에 둔다는 기준입니다.

**import 목록은 자동이 아니다.** `plugins/init.lua` 의 `require("lazy").setup({...})`
안에 `{ import = "plugins.<이름>" }` 을 직접 적어야 합니다. 파일만 새로 만들면
로드되지 않으니 주의하세요.

## 플러그인별 메모

| 파일 | 플러그인 | 알아둘 것 |
|---|---|---|
| `lsp.lua` | mason, nvim-lspconfig, mason-lspconfig, nvim-cmp | LSP 서버는 `:Mason` 으로 관리. Python 은 npm 이 필요 없도록 pyright 대신 `jedi-language-server` 사용 |
| `treesitter.lua` | nvim-treesitter | `master` 브랜치. 파서는 `auto_install` 로 진입 시 자동 설치 |
| `format.lua` | conform.nvim | 저장 시 자동 포맷. 포매터 바이너리가 없으면 조용히 건너뜀 |
| `telescope.lua` | telescope (`0.1.6` 고정), fzf-native | `rg` 가 있으면 쓰고 없으면 시스템 `grep` 으로 폴백 |
| `ui.lua` | tokyonight | `storm` 스타일, 배경 투명. 비활성 창만 배경색을 넣어 구분 |
| `harpoon.lua` | harpoon (`harpoon2`) | `M-1`~`M-4` 는 독립 터미널에서만 확실히 동작 |
| `undotree.lua` | undotree | `<leader>u` 로 지연 로드 |
| `tmux-navigator.lua` | vim-tmux-navigator | `C-h/j/k/l` 이 nvim split 과 tmux pane 을 구분 없이 넘나듦. **tmux 쪽 짝은 `.tmux.conf` 에 있고 TPM 설치가 필요**. tmux 밖에서도 split 이동으로는 그대로 동작 |
| `claudecode.lua` | claudecode.nvim, plenary | **`claude` CLI 가 PATH 에 있어야 함.** snacks.nvim 미설치라 내장 터미널 사용 |

## 자주 하는 작업

```vim
:Lazy          " 플러그인 상태 확인 / 설치 / 업데이트
:Lazy restore  " lazy-lock.json 에 고정된 커밋으로 되돌리기
:Mason         " LSP 서버 설치 관리
:checkhealth   " 진단
:ConformInfo   " 현재 버퍼에 어떤 포매터가 붙는지
```

플러그인을 업데이트했다면 `nvim/lazy-lock.json` 변경분도 함께 커밋하세요.
