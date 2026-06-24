# 키맵 치트시트

현재 설정의 전체 키 바인딩. (개요·설치는 [README](../README.md) 참고)

- **nvim leader = `Space`**
- **tmux prefix = `C-a`**
- 표기: `C-x`=Ctrl, `M-x`=Alt, `<leader>`=Space

---

## tmux  (`~/.tmux.conf`)

| 키 | 동작 |
|---|---|
| `C-a` | prefix (기본 `C-b` 에서 변경) |
| `C-a \|` | 좌우 분할 (현재 경로 유지) |
| `C-a -` | 상하 분할 (현재 경로 유지) |
| `C-a c` | 새 window (현재 경로) |
| `C-a h/j/k/l` | 패인 이동 (Vi 방향) |
| `C-a H/J/K/L` | 패인 크기 조절 (반복 가능) |
| `C-a p` / `C-a n` | 이전 / 다음 window (반복 가능) |
| `C-a Enter` | 복사 모드 진입 |
| └ `v` / `y` / `Esc` | 선택 시작 / 복사 / 취소 (복사 모드 내) |
| `C-a r` | 설정 리로드 |

기타: 마우스 on, `base-index 1`, `escape-time 0`(Esc 딜레이 제거), Catppuccin Mocha 상태바.

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

> `ps`/`pg` 는 ripgrep 이 있으면 rg, 없으면 시스템 grep 으로 **자동 폴백**. (42 클러스터·SSH 박스에서 무설치 동작)

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
| `C-Space` | 자동완성 띄우기 |
| `CR` / `Tab` | 확정 (Tab은 스니펫 점프 겸용) |
| `S-Tab` | 위 항목 / 스니펫 역방향 |
| `C-n` / `C-p` | 다음 / 이전 항목 |
| `C-b` / `C-f` | 문서 스크롤 |

### Quickfix / 치환  (`keymaps.lua`)
| 키 | 동작 |
|---|---|
| `C-j` / `C-k` | 다음 / 이전 quickfix (중앙 고정) |
| `<leader>s` | 커서 밑 단어 전체 치환 |

### 터미널  (`keymaps.lua`)
| 키 | 동작 |
|---|---|
| `<leader>th` / `<leader>tv` | 가로 / 세로 분할 터미널 |
| `<Esc>` | 터미널 → Normal 모드 |

### 42 / C 워크플로우  (`keymaps.lua`)
| 키 | 동작 |
|---|---|
| `<leader>n` | norminette 실행 |
| `<leader>r` | 저장 후 `42run` |
| `<leader>co` | `42clean` |
| `<leader>m` | 저장 후 `make` |
| `<leader>mc` | `make fclean` |

---

## 모드별 키 중복 메모 (충돌 아님)

같은 키라도 모드가 달라서 안 부딪힘:

| 키 | normal | insert |
|---|---|---|
| `C-p` | Telescope git files | cmp 이전 항목 |
| `C-n` | (없음) | cmp 다음 항목 |
| `C-f` | (예약: 추후 sessionizer) | cmp 문서 스크롤 |
