-- ==========================================
-- UI / 테마 / 시각적 설정
-- ==========================================

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,      -- 즉시 로드
    priority = 1000,   -- 다른 플러그인보다 먼저 로드
    config = function()
      -- 1. Tokyonight 기본 설정 (투명도 활성화)
      require("tokyonight").setup({
        style = "storm", -- 취향에 따라 "moon"이나 "night"로 변경 가능
        transparent = true, -- 현재 창 배경 투명하게
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })

      -- 2. 테마 적용
      vim.cmd.colorscheme("tokyonight")

      -- 3. 창 강조 효과: 비활성 창(NormalNC)에만 배경색 입히기
      -- #16161e는 Tokyonight 특유의 어두운 남색입니다.
      -- 너무 밝거나 어두우면 "#0f0f14" (더 어두운 색) 등으로 바꿔보세요.
      -- 더 밝게 하고 싶다면: bg = "#2f334d"
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#24283b" })
    end,
  },
  -- Treesitter 설정은 plugins/treesitter.lua 로 분리됨
}
