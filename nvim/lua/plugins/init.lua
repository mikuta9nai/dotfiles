-- ==========================================
-- 플러그인 매니저 (Lazy.nvim) 부트스트랩
-- ==========================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- vim.loop → vim.uv (Neovim 0.10+ 권장)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins/ 하위 모듈 목록. 각 파일은 lazy.nvim 플러그인 스펙(테이블)을 return 합니다.
-- 자동 탐색이 아니므로 파일을 추가하면 이 목록에도 등록해야 로드됩니다.
require("lazy").setup({
  { import = "plugins.lsp" },
  { import = "plugins.treesitter" },
  { import = "plugins.format" },
  { import = "plugins.telescope" },
  { import = "plugins.ui" },
  { import = "plugins.harpoon" },
  { import = "plugins.undotree" },
}, {
  -- lazy.nvim 자체 옵션
  checker = { enabled = false },  -- 자동 업데이트 체크 비활성화
  change_detection = { notify = false },
})
