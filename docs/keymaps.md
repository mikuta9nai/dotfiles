# 키맵 치트시트

현재 설정의 전체 키 바인딩. (개요·설치는 [README](../README.md) 참고)

- **nvim leader = `Space`**
- **tmux prefix = `C-Space`**
- 표기: `C-x`=Ctrl, `M-x`=Alt, `<leader>`=Space

---

## tmux  (`~/.tmux.conf`)

| 키 | 동작 |
|---|---|
| `C-Space` | prefix (기본 `C-b` 에서 변경) |
| `C-h/j/k/l` | **pane/split 이동** — nvim split ↔ tmux pane 심리스 (prefix 없이, vim-tmux-navigator) |
| `C-Space \|` | 좌우 분할 (현재 경로 유지) |
| `C-Space -` | 상하 분할 (현재 경로 유지) |
| `C-Space c` | 새 window (현재 경로) |
| `C-Space H/J/K/L` | 패인 크기 조절 (반복 가능) |
| `C-Space p` / `C-Space n` | 이전 / 다음 window (반복 가능) |
| `C-Space C-l` | 화면 지우기 (pane 이동에 뺏긴 C-l 복구) |
| `C-Space Enter` | 복사 모드 진입 |
| └ `v` / `y` / `Esc` | 선택 시작 / 복사 / 취소 (복사 모드 내) |
| `C-Space r` | 설정 리로드 |

기타: 마우스 on, `base-index 1`, `escape-time 0`(Esc 딜레이 제거), Tokyo Night (Storm) 상태바.
`C-h/j/k/l` 심리스 이동은 첫 설치 후 **`C-Space` + `I`** 로 vim-tmux-navigator 플러그인을 받아야 작동.

---

## Neovim

### 기본 이동 / QoL  (`keymaps.lua`)
| 키 | 모드 | 동작 |
|---|---|---|
| `<leader>pv` | n | netrw 파일 탐색기 |
| `J` / `K` | v | 선택 블록 아래 / 위로 이동 |
| `J` | n | 줄 합치기 (커서 위치 유지) |
| `C-d` / `C-u` | n | 반 페이지 스크롤 (커서 중앙 고정) |
| `n` / `N` | n | 다음 / 이전 검색 (커서 중앙 고정) |
| `<Esc>` | n | 검색 하이라이트 해제 |
| `Q` | n | 비활성화 (실수로 Ex 모드 진입 방지) |

### 창 이동  (`plugins/tmux-navigator.lua`)
| 키 | 동작 |
|---|---|
| `C-h/j/k/l` | nvim split ↔ tmux pane 심리스 이동 (prefix 불필요) |

### 복사 / 붙여넣기  (`keymaps.lua`)
| 키 | 모드 | 동작 |
|---|---|---|
| `<leader>p` | x | 붙여넣어도 레지스터 안 날아감 |
| `<leader>y` / `<leader>Y` | n,v | 시스템 클립보드로 복사 / 줄 복사 |
| `<leader>d` | n,v | 블랙홀 레지스터로 삭제 (레지스터 오염 방지) |

### Harpoon  (`plugins/harpoon.lua`)
| 키 | 동작 |
|---|---|
| `<leader>a` | 현재 파일 작살 추가 |
| `C-e` | 작살 메뉴 토글 |
| `M-1` ~ `M-4` | 작살 1~4번 파일로 점프 |
| `M-p` / `M-n` | 이전 / 다음 작살 파일 |

> ⚠️ `M-1~4`는 독립 터미널(Ghostty 등)에서 작동. **VSCode 통합 터미널**에선 Alt+숫자가 VSCode에 먹힐 수 있음.

### Telescope  (`plugins/telescope.lua`)  — 컨벤션 `p*` = project
| 키 | 동작 |
|---|---|
| `<leader>pf` | 모든 파일 찾기 |
| `C-p` | git 추적 파일만 |
| `<leader>ps` | 단어 입력받아 전체 grep (`Grep >` 프롬프트) |
| `<leader>pg` | 실시간 live grep |
| `<leader>pb` | 열린 버퍼 |
| `<leader>pr` | 최근 파일 |
| `<leader>vh` | 도움말 태그 |
| **목록 내** `C-j`/`C-k` | 아래 / 위 이동 |
| **목록 내** `C-q` | 선택을 quickfix 로 |
| **목록 내** `Esc` | 닫기 |

> `ps`/`pg` 는 ripgrep 이 있으면 rg, 없으면 시스템 grep 으로 **자동 폴백**. (낯선 SSH 박스에서 무설치 동작)

### LSP  (`plugins/lsp.lua`, 파일 열릴 때 등록)
| 키 | 동작 |
|---|---|
| `gd` | 정의로 이동 |
| `K` | 호버 문서 |
| `<leader>vd` | 현재 줄 진단 |
| `<leader>vca` | 코드 액션 |
| `<leader>vrr` | 참조 찾기 |
| `<leader>vrn` | 이름 변경 (리네임) |
| `<leader>vws` | 워크스페이스 심볼 |
| `[d` / `]d` | 이전 / 다음 진단 |

### 자동완성 cmp  (insert 모드, `plugins/lsp.lua`)
| 키 | 동작 |
|---|---|
| `CR` / `Tab` | 확정 (Tab은 스니펫 점프 겸용) |
| `S-Tab` | 위 항목 / 스니펫 역방향 |
| `C-n` / `C-p` | 다음 / 이전 항목 |
| `C-b` / `C-f` | 문서 스크롤 |

### 포맷 / 히스토리
| 키 | 모드 | 동작 |
|---|---|---|
| `<leader>cf` | n,v | 버퍼/선택 영역 포맷 (`plugins/format.lua`) |
| `<leader>u` | n | Undotree 토글 (`plugins/undotree.lua`) |

> 저장 시 모든 파일 타입이 자동 포맷됩니다. `<leader>cf` 는 수동 실행용.
> 포매터 바이너리가 없으면 조용히 건너뜁니다.

### Quickfix / 치환  (`keymaps.lua`)
| 키 | 동작 |
|---|---|
| `]q` / `[q` | 다음 / 이전 quickfix (중앙 고정) |
| `<leader>s` | 커서 밑 단어 전체 치환 |

### 터미널  (`keymaps.lua`)
| 키 | 동작 |
|---|---|
| `<leader>th` / `<leader>tv` | 가로 / 세로 분할 터미널 |
| `<Esc>` | 터미널 → Normal 모드 |

### 빌드  (`keymaps.lua`)
| 키 | 동작 |
|---|---|
| `<leader>m` | 저장 후 `make` |
| `<leader>mc` | `make fclean` |

### Claude Code  (`plugins/claudecode.lua`)
| 키 | 모드 | 동작 |
|---|---|---|
| `<leader>cc` | n | Claude 토글 |
| `<leader>cF` | n | Claude 창으로 포커스 |
| `<leader>cr` | n | 이전 세션 재개 (`--resume`) |
| `<leader>cC` | n | 마지막 대화 이어가기 (`--continue`) |
| `<leader>cb` | n | 현재 버퍼를 컨텍스트로 추가 |
| `<leader>cs` | v | 선택 영역 보내기 |
| `<leader>ct` | n | 파일 탐색기에서 파일 추가 |
| `<leader>cy` / `<leader>cn` | n | 제안된 diff 수락 / 거절 |

> `claude` CLI 가 PATH 에 있어야 동작합니다.

---

## 모드별 키 중복 메모 (충돌 아님)

같은 키라도 모드가 달라서 안 부딪힘:

| 키 | normal | insert |
|---|---|---|
| `C-p` | Telescope git files | cmp 이전 항목 |
| `C-n` | (없음) | cmp 다음 항목 |
| `C-f` | (예약: 추후 sessionizer) | cmp 문서 스크롤 |

`<leader>c` 는 Claude Code 네임스페이스지만 `<leader>cf`(포맷) 하나가 같이 들어와
있습니다. 뒷글자가 겹치지 않아 충돌은 없습니다.

`C-h/j/k/l` 은 tmux(pane) 와 nvim(split) 양쪽이 같은 키를 쓰지만, vim-tmux-navigator
가 지금 커서가 어느 쪽에 있는지 보고 넘겨주므로 충돌이 아니라 **한 쌍**입니다.
