# macOS 선언적 개발 환경 구축

M1 MacBook Air를 씬클라이언트로, 집 워크스테이션을 실제 작업 머신으로 쓰기 위한 셋업 기록.

**원칙**

- 아래층부터가 아니라 **오늘 당장 쓸모가 생기는 것부터**
- Nix는 확정된 설정을 고정하는 도구지, 설정을 탐색하는 도구가 아니다 → 마지막
- 0~2단계가 본체. 3단계부터는 전부 선택
- 실행한 명령은 전부 이 파일 하단 「실행 로그」에 기록 → 5단계의 입력값

---

## 전체 그림

| 단계 | 내용 | 소요 | 완료 시 |
|---|---|---|---|
| 0 | SSH + 원격 tmux | 30분 | 실용 가치의 80% |
| 1 | Tailscale + 접속 자동화 | 2~3시간 | 집 밖에서도 동일 |
| 2 | 원격 작업 환경 정리 | 며칠 (틈틈이) | 개발이 쾌적해짐 |
| 3 | AeroSpace | 2시간 | 로컬 창 관리 |
| 4 | SketchyBar | 반나절 | 보기 좋아짐 |
| 5 | Nix 이관 | 주말 하나 | 재현 가능해짐 |
| 6 | 발표 모드 · 테마 | 무한 | 재미 |

> **시간 제한:** 3단계 이후에 주말 하나 이상 쓰지 않는다.
> 2단계 시점에서 목적은 이미 달성된 상태다.

---

## 층 구조 (참고)

```
원격 워크스테이션    Tailscale · SSH/mosh · 원격 tmux      실제 연산이 도는 곳
        ↑
작업 환경 층         Ghostty · tmux · Neovim               실제로 일하는 화면
데스크톱 셸 층       AeroSpace · SketchyBar · borders      배치와 표시
선언적 관리 층       flake · nix-darwin · home-manager     위 전부를 코드로 고정
macOS 기반 층        M1 Air · 절전 · GUI · 권한            손대지 않는 토대
```

화살표가 두 방향이라는 점에 주의.

- **관리 방향** — 선언적 관리 층이 위쪽 층들을 *설정*한다 (아래 → 위)
- **사용 방향** — 사용자는 위쪽 층을 *쓴다* (데스크톱 셸 → 터미널 → 원격)

Nix는 설치 관리자일 뿐 런타임 의존성이 아니다. Nix 없이도 AeroSpace는 잘 돈다.
그래서 손으로 먼저 만들고 나중에 관리 방향만 붙이면 된다.

각 층이 독립적으로 고장 나게 유지할 것. SketchyBar가 죽어도 AeroSpace는 돌고,
Tailscale이 끊겨도 로컬 작업은 되어야 한다. 셸 프롬프트가 매번 원격을 SSH 조회하게
만들면 네트워크 끊길 때 터미널 자체가 먹통이 된다.

---

## 0단계 — 오늘 (30분)

- [ ] 워크스테이션에 tmux 설치 확인
- [ ] 맥북 `~/.ssh/config`에 `Host ws` 등록
- [ ] `ssh -t ws 'tmux new-session -A -s main'` 동작 확인
- [ ] 셸 함수 `ws()`로 감싸기
- [ ] 뚜껑 닫았다 열고 재접속 — **얼마나 답답한지 체감**

```
Host ws
    HostName <워크스테이션 주소>
    User <계정>
    ServerAliveInterval 30
    ServerAliveCountMax 3
```

- `ServerAliveInterval` — 뚜껑 닫았다 열었을 때 죽은 세션이 매달려 있는 걸 방지
- `-A` — 세션 있으면 붙고 없으면 생성
- `-t` — TTY 강제 할당. 없으면 tmux가 안 뜬다

마지막 체크 항목이 1단계에서 mosh를 넣을지 결정한다. 처음부터 깔지 말고 불편을 먼저 겪을 것.

**완료 기준:** `ws` 한 번으로 원격 tmux에 붙는다.

---

## 1단계 — 이번 주

- [ ] 워크스테이션에 `tailscaled` 설치 (CLI 버전)
- [ ] 맥북에 Tailscale GUI 설치 — **Standalone 또는 App Store 중 하나만**
- [ ] 맥북 셸에 alias 등록
- [ ] 양쪽 `tailscale up` → 브라우저 인증 ← **수동**
- [ ] MagicDNS 이름으로 SSH 되는지 확인
- [ ] `~/.ssh/config`의 HostName을 Tailscale 이름으로 교체
- [ ] (0단계에서 답답했으면) mosh 추가
- [ ] WoL 스크립트를 맥북에서 호출 가능하게 정리

```sh
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
```

zsh 자동완성까지 쓸 거면 실행 파일이 대문자라 한 줄 더 필요:

```sh
compdef _tailscale Tailscale
```

**주의**

- App Store 버전과 Standalone 버전을 같이 깔면 Network Extension이 안 뜬다
- 심볼릭 링크로 `/usr/local/bin`에 걸면 멈추는 문제가 있음 → alias로 갈 것
- 맥북은 GUI 앱 (절전·복귀·Wi-Fi 전환에 강함), 워크스테이션은 CLI 데몬
  (로그인 전 부팅 시점부터 올라와야 WoL 직후 바로 붙는다)

**완료 기준:** 학교 와이파이에서 `ws` 한 번으로 워크스테이션 tmux에 붙는다.

---

## 2단계 — 원격 작업 환경 정리

로컬이 아니라 **워크스테이션 쪽**부터. 시간의 90%를 여기서 보낸다.

- [x] 원격 tmux 설정 (프리픽스 `C-Space`, 분할 키, TPM resurrect/continuum 세션 복원)
- [ ] 로컬/원격 tmux 프리픽스 충돌 정리 — 또는 로컬 tmux 생략 결정
- [ ] Neovim 설정 정리
- [ ] 셸 프롬프트에 호스트 색상 구분 (로컬 vs 워크스테이션)
- [ ] 프로젝트별 tmux 세션 시작 스크립트

프롬프트 색상 구분은 취향이 아니라 실수 방지 장치다.

> 이 저장소의 L1~L5 레이어(폰트·Ghostty·tmux·zsh+Starship·CLI 도구)가 2단계의
> "원격 작업 환경"에 해당한다. 구성은 [README](../README.md), 도구 설치는
> [tools.md](tools.md) 참고. 즉 2단계는 **어느 머신에 무엇을 링크할지**(`install.sh`
> 의 `--minimal`)를 정하는 문제로 좁혀진 상태다.

**여기까지가 본체. 아래는 전부 선택.**

---

## 3단계 — AeroSpace

- [ ] `brew install aerospace`
- [ ] 접근성 권한 승인 ← **수동**
- [ ] `aerospace.toml` 작성 — 워크스페이스 1~5 + 키바인딩
- [ ] 1번 워크스페이스에 터미널 자동 배치
- [ ] JankyBorders 추가

```
1  terminal / remote dev
2  browser / docs
3  communication
4  notes
5  local utilities

P  발표 전용
```

**주의**

- AeroSpace는 pre-1.0이라 마이너 버전 사이에 TOML 키가 바뀐 적이 있다.
  남의 설정 참고할 때 **그 사람이 쓴 버전 확인**
- 리싱(꾸미기)은 메인테이너 관심사가 아니다. gaps와 바 연동 콜백 정도만 기대할 것
- yabai 대비 장점은 SIP를 끌 필요가 없다는 것. macOS 업데이트에 안 깨진다

---

## 4단계 — SketchyBar

- [ ] AeroSpace **네이티브** 설정 2~3개 클론해서 각각 20분씩 띄워보기
- [ ] 하나 골라 fork — upstream remote 유지 (나중에 diff 뜨려고)
- [ ] 폰트 설치 확인 — 아이콘이 두부로 나오면 폰트 문제
- [ ] 색상만 취향에 맞게 수정 → `--reload`
- [ ] 워크스테이션 상태 item 직접 추가

**미리 알고 갈 개념 (30분이면 충분)**

- 설정 파일은 선언적 파일이 아니라 `sketchybar --set ...`을 쏘는 셸 스크립트
- 구성 요소 넷: `bar`(막대) / `item`(요소) / `plugin`(갱신 스크립트) / `event`(트리거)
- 갱신은 `update_freq`(주기) 또는 `--subscribe`(이벤트)
- 고치면 `sketchybar --reload`

**yabai 설정을 가져오면 안 되는 이유**

워크스페이스 인디케이터·창 제목·레이아웃 표시가 전부 창 관리자 이벤트에 물려 있다.
yabai 설정을 AeroSpace에 붙이면 바는 뜨는데 왼쪽이 죽어 있다.
예쁜 yabai 설정이 있으면 색상·아이템 디자인만 나중에 참고할 것.

**워크스테이션 상태 위젯**

```sh
tailscale status --json | jq -r '...'
```

`tailscale status`는 로컬 데몬 조회라 싸다 → 주기적으로 돌려도 무방.
GPU 사용률 같은 **원격 SSH 조회는 클릭 시에만** 갱신 (배터리·네트워크 낭비 방지).

---

## 5단계 — Nix 이관

여기 오기 전에 하단 「실행 로그」가 채워져 있어야 한다.

- [ ] Nix 설치
- [ ] `flake.nix` 뼈대 + nix-darwin
- [ ] home-manager를 nix-darwin 모듈로 연결
- [ ] Homebrew 목록을 nix-darwin homebrew 모듈로 이관
- [ ] dotfiles를 `home/`으로 이관 (워크스테이션과 공유되는 부분 우선)
- [ ] `hosts/`로 맥북·워크스테이션 분리
- [ ] 클린 상태에서 재현 테스트

```
dotfiles/
├── flake.nix
├── flake.lock
├── hosts/
│   ├── macbook-air/
│   └── workstation/
├── modules/
│   ├── darwin/        system.nix homebrew.nix aerospace.nix
│   ├── linux/
│   └── common/        packages.nix ssh.nix tailscale.nix theme.nix
├── home/              common.nix darwin.nix linux.nix
├── programs/          neovim/ tmux/ ghostty/ sketchybar/ shell/
├── themes/
└── scripts/           bootstrap.sh connect-workstation wake-workstation
```

핵심은 맥북과 워크스테이션이 `common`과 `home`을 **공유**하는 것.

**알아둘 마찰**

- macOS 메이저 업데이트 때 nix-darwin이 깨질 수 있다.
  새 버전 나오면 바로 올리지 말고 며칠 기다릴 것
- Homebrew 선언화는 반쪽이다. 앱 버전까지 고정되지 않는다 → "목록 관리" 수준
- `defaults` 일부는 재로그인/재부팅 전엔 반영 안 되고, 버전에 따라 무시되는 키도 있다

---

## 6단계 — 나머지

- [ ] 발표 모드 스크립트 (`P` 워크스페이스만 외부 디스플레이로)
- [ ] 배경 이미지 → 공통 팔레트 추출
- [ ] Neovim / tmux / Ghostty / SketchyBar 팔레트 통일

Stylix는 테마의 유일한 주인이 아니라 **팔레트 생성기**로 볼 것.
darwin 지원 커버리지가 Linux보다 좁다.

발표 워크스페이스에는 개인 배경·채팅·알림·상태바 정보를 넣지 않는다.
브라우저 / PDF / 슬라이드 / 데모만.

---

## 수동 권한 체크리스트

자동화 불가능한 5%. 기기 초기화하거나 새 기기 세팅할 때 이 목록이 있어야
"왜 안 되지"를 안 겪는다.

- [ ] macOS 최초 사용자 생성
- [ ] Apple 계정 로그인
- [ ] Touch ID 등록
- [ ] 접근성 권한 — AeroSpace, Karabiner
- [ ] 입력 모니터링 권한 — Karabiner
- [ ] 화면 녹화 권한 — (필요 시)
- [ ] Tailscale 브라우저 인증
- [ ] App Store 인증
- [ ] 앱별 최초 실행 승인

---

## 실행 로그

5단계의 입력값. 명령을 실행할 때마다 여기 추가할 것.

### 설치한 것

```
(brew install ..., 다운로드한 앱 등)
```

### 손으로 바꾼 설정

```
(파일 경로 + 무엇을 바꿨는지)
```

### defaults 명령

```
(defaults write ...)
```

---

## 판단 기록

나중에 "왜 이렇게 했더라" 할 때 참고.

- **새 노트북 안 삼** — M1 Air 16GB/1TB가 씬클라이언트로 이미 이상적. 팬리스·배터리·Apple Silicon
- **NixOS 대신 macOS 유지** — macOS는 하드웨어·절전·GUI 기반으로 두고 그 위를 선언적으로
- **yabai 대신 AeroSpace** — SIP 유지, macOS 업데이트 내성, TOML 하나로 관리.
  용도(터미널+브라우저)에 BSP나 세밀한 창 규칙이 필요 없음
- **Nix를 마지막에** — 설정이 확정되기 전에 flake부터 짜면 계속 갈아엎게 된다
- **남의 SketchyBar 설정 이식** — 직접 짜면 며칠, 가져오면 반나절.
  커스텀 위젯(워크스테이션 상태)만 직접 만들면 됨
- **외부 모니터** — M1 Air는 외부 디스플레이 1대 전제. 학교 미러링은 문제없음
