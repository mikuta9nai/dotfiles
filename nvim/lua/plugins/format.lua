-- ==========================================
-- 포매터 (conform.nvim)
-- ==========================================
-- 저장 시 자동 포맷. <leader>cf 로 수동 실행도 가능합니다.
--
-- 포매터 바이너리는 PATH 또는 Mason 에서 찾습니다. 없으면 조용히 건너뜀.
--   rustfmt      : rustup 과 함께 설치됨
--   stylua       : :MasonInstall stylua
--   ruff         : :MasonInstall ruff   (또는 black)
--   clang-format : clangd 와 함께 설치되는 경우가 많음

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer/selection",
    },
  },
  opts = {
    formatters_by_ft = {
      python = { "ruff_format", "black", stop_after_first = true },
      rust = { "rustfmt" },
      lua = { "stylua" },
      c = { "clang_format" },
      cpp = { "clang_format" },
    },

    -- 저장 시 자동 포맷
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  },
}
