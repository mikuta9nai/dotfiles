# ==========================================
# dotfiles 설치 스크립트 (Windows / PowerShell)
# ==========================================
# dotfiles 안의 설정들을 올바른 위치로 심볼릭 링크합니다.
# 기존 파일이 있으면 .bak 으로 백업한 뒤 링크합니다.
#
# 사용법 (PowerShell):  .\install.ps1
#
# [주의] 심볼릭 링크 생성에는 다음 중 하나가 필요합니다.
#   - 관리자 권한으로 PowerShell 실행, 또는
#   - Windows 개발자 모드 활성화
#     (설정 > 개인 정보 및 보안 > 개발자용)

$ErrorActionPreference = "Stop"

# 이 스크립트가 위치한 디렉토리 = dotfiles 루트
$Dotfiles = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Link <소스> <대상>
function Link {
    param([string]$Src, [string]$Dst)

    $parent = Split-Path -Parent $Dst
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    $item = Get-Item $Dst -ErrorAction SilentlyContinue
    if ($null -ne $item) {
        if ($item.LinkType -eq "SymbolicLink") {
            Remove-Item $Dst -Force          # 기존 심링크 교체
        }
        else {
            $backup = "$Dst.bak." + (Get-Date -Format "yyyyMMddHHmmss")
            Move-Item $Dst $backup
            Write-Host "  기존 파일 백업: $backup"
        }
    }

    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
    Write-Host "  링크 생성: $Dst -> $Src"
}

Write-Host "dotfiles 설치 시작 (루트: $Dotfiles)"

# ── 링크 매핑 ─────────────────────────────
# Windows 의 Neovim 설정 경로는 %LOCALAPPDATA%\nvim
Link "$Dotfiles\nvim" "$env:LOCALAPPDATA\nvim"
# 예시 (추후):
# Link "$Dotfiles\git\.gitconfig" "$env:USERPROFILE\.gitconfig"
# ──────────────────────────────────────────

Write-Host "완료. Neovim 을 처음 실행하면 플러그인이 자동 설치됩니다."
