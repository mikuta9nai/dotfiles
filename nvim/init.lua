-- ==========================================
-- Neovim Configuration Entry Point
-- ==========================================
-- 각 모듈을 순서대로 로드합니다.
-- 플러그인 매니저(lazy.nvim)가 mapleader에 의존하므로
-- options → plugins 순서를 지켜야 합니다.

require("options")      -- 기본 옵션 (number, tab, clipboard 등)
require("keymaps")      -- 플러그인 무관 일반 키맵
require("autocmds")     -- autocommand 모음
require("plugins")      -- lazy.nvim 부트스트랩 + 플러그인 로드
