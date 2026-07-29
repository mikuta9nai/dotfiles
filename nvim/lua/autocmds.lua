-- ==========================================
-- Autocommands
-- ==========================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- 저장 시 줄 끝 공백 자동 제거
autocmd("BufWritePre", {
  group = augroup("TrailingWhitespace", {}),
  pattern = "*",
  command = [[%s/\s\+$//e]],
  desc = "Strip trailing whitespace on save",
})

-- Yank(복사) 시 하이라이트 표시 (ThePrimeagen 스타일)
-- 복사된 영역이 잠깐 번쩍여서 뭘 복사했는지 시각적으로 확인 가능
autocmd("TextYankPost", {
  group = augroup("HighlightYank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
  desc = "Highlight yanked text briefly",
})

-- ==========================================
-- 프로젝트 루트 자동 감지 (Smart Root)
-- Makefile, .git, .clangd 등이 있는 곳으로 cd
-- ==========================================
autocmd("VimEnter", {
  group = augroup("SmartRoot", {}),
  callback = function()
    local root_markers = { ".clangd", "Makefile", ".git", "go.mod" }
    local current_dir = vim.fn.expand("%:p:h")

    local found = vim.fs.find(root_markers, { path = current_dir, upward = true })[1]
    if found then
      local root_dir = vim.fs.dirname(found)
      vim.cmd("cd " .. root_dir)
    end
  end,
  desc = "Auto-detect project root on startup",
})
