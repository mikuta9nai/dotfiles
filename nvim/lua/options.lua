-- ==========================================
-- 기본 설정 (Basic Options)
-- ==========================================

-- Leader Key는 플러그인 로드 전에 반드시 설정
vim.g.mapleader = " "

local opt = vim.opt

-- 줄 번호
opt.number = true
opt.relativenumber = true

-- 구문 강조
opt.syntax = "on"

-- 들여쓰기
opt.expandtab = true        -- Tab 을 스페이스로
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- 시스템 클립보드 연동
opt.clipboard:append("unnamedplus")

-- 자동완성 메뉴 옵션
opt.completeopt = { "menu", "menuone", "noselect" }
