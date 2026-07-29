# 안전망과 되돌리기

설정을 실험하다 **처음 상태로 즉시 돌아오기** 위한 문서.
층마다 방법이 다르고, 한 층은 원래 자동 복구가 안 된다.

| 층 | 무엇 | 되돌리는 법 |
|---|---|---|
| 설정 파일 | `nvim/` `tmux/` `zsh/` `aerospace/` … | git — **완전히 됨** |
| 링크 | `~/.config/*` `~/.tmux.conf` … | `./install.sh` 재실행 (멱등) |
| 프로그램 | brew 패키지 | `Brewfile` — 목록만. 버전은 아님 |
| 시스템 설정 · 권한 | 접근성, `defaults write` | **자동 불가** — 기록만이 유일한 수단 |

심볼릭 링크 구조라서 `git checkout` 하는 순간 설정이 즉시 바뀐다. 별도 배포 단계가 없다.
단 링크 매핑 자체가 바뀌었으면 `./install.sh` 를 한 번 더 돌린다.

---

## 1. 안전망 만들기 (한 번만)

### 지금 상태에 이름 붙이기

```bash
git tag -a baseline-terminal -m "터미널 레이어 완성 (L1~L5 + nvim)"
git push origin baseline-terminal
```

의미 있는 지점마다 태그를 추가한다 (`baseline-desktop` 등).
나중에 붙이려면 "어느 커밋이었지"를 뒤져야 하므로 **그 시점에** 붙일 것.

### brew 패키지 목록 고정

```bash
brew bundle dump --describe --file=Brewfile      # 이미 있으면 --force 추가
git add Brewfile && git commit -m "brew: 패키지 목록 갱신"
```

**기준선은 깨끗할 때 떠야 의미가 있다.** 남의 설정을 여러 개 시험해 본 뒤에
뜨면 그 지저분한 상태가 "돌아갈 곳"이 된다.

---

## 2. 되돌리기

### 커밋 안 한 변경 버리기

```bash
git checkout -- .
```

### 최신 상태로

```bash
git checkout main && ./install.sh
```

### 특정 시점으로

```bash
git checkout baseline-terminal && ./install.sh
...
git checkout main && ./install.sh    # 돌아오기
```

> 태그를 checkout 하면 detached HEAD 가 된다. **그 상태에서 편집하지 말 것.**
> 그 시점에서 갈라져 나가려면 `git checkout -b <새브랜치> baseline-terminal`.

### 프로그램 목록 복원

```bash
brew bundle check   --file=Brewfile          # 뭐가 다른지 확인만
brew bundle         --file=Brewfile          # 목록에 있는데 없는 것 → 설치
brew bundle cleanup --file=Brewfile          # 지워질 것 나열 (실제로는 안 지움)
brew bundle cleanup --file=Brewfile --force  # ⚠️ 실제 삭제
```

`cleanup` 은 **Brewfile 에 없는 패키지를 지운다.** 의도적으로 깐 것을 Brewfile 에
적어두지 않았으면 그것도 지워진다. `--force` 없이 먼저 목록을 확인할 것.

---

## 3. 실험 워크플로

```bash
git checkout -b try/aerospace
#   ... 설정 만지기 ...
./install.sh                 # 링크 매핑을 건드렸으면

# 채택
git checkout main && git merge try/aerospace && ./install.sh

# 폐기
git checkout main && ./install.sh
git branch -D try/aerospace
```

**주의 — 고아 링크.** 실험 브랜치에서 새 링크(`~/.config/aerospace` 등)를 만들었으면
main 으로 돌아가도 그 링크는 남는다. main 의 `install.sh` 는 그런 게 있는 줄 모른다.
손으로 지울 것. 대부분의 실험은 기존 파일 *내용* 변경이라 이 문제가 없다.

### 워크스테이션에 반영

```bash
ssh 3070 'cd ~/dotfiles && git pull --ff-only && ./install.sh --minimal'
```

---

## 4. 되돌릴 수 없는 것

**macOS 시스템 설정과 권한** — 접근성 권한, `defaults write`, 앱별 최초 실행 승인.
되돌리는 도구가 없다. 기록이 유일한 복구 수단이므로
[roadmap.md](roadmap.md) 의 「실행 로그」와 「수동 권한 체크리스트」를 그때그때 채울 것.

**brew 패키지의 버전** — `Brewfile` 은 "무엇이 깔려 있는가"만 고정한다.
버전 고정은 Nix 이관(로드맵 5단계) 이후의 이야기다.

> 정말 위험한 작업 전에는 `tmutil localsnapshot` 으로 APFS 스냅샷을 뜰 수 있다.
> 시스템 전체라 무겁다. 창 관리자·상태바 수준의 작업에는 과하다.
