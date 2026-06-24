-- ==========================================
-- 포매터 (conform.nvim)
-- ==========================================
-- 저장 시 자동 포맷. 단, C/C++는 42 Norminette 규칙과 충돌할 수 있어
-- 자동 포맷에서 제외하고, 필요할 때 <leader>cf 로만 수동 실행합니다.
--
-- 포매터 바이너리는 PATH 또는 Mason 에서 찾습니다. 없으면 조용히 건너뜀.
--   rustfmt : rustup 과 함께 설치됨
--   stylua  : :MasonInstall stylua
--   ruff    : :MasonInstall ruff   (또는 black)

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
    },

    -- 저장 시 자동 포맷 (C/C++ 는 Norminette 충돌 방지로 제외)
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      if ft == "c" or ft == "cpp" then
        return  -- 자동 포맷 안 함
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
}
