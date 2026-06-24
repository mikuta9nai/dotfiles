-- ==========================================
-- 42 Header & Norminette
-- ==========================================
return {
  -- 42 공식 헤더
  {
    "42Paris/42header",
    -- 파일이 열릴 때 이 설정을 로드해야 자동 갱신(autocmd)이 작동합니다.
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.g.user42 = "gangjeon"
      vim.g.mail42 = "gangjeon@student.42gyeongsan.kr"

      -- 저장 시 자동 갱신 로직
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.c", "*.h" },
        callback = function()
          -- 첫 번째 줄을 가져옴
          local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

          -- 알려주신 첫 줄 문자열과 정확히 일치하는지 확인
          local header_start = "/* ************************************************************************** */"

          if first_line == header_start then
            vim.cmd("Stdheader")
          end
        end,
      })
    end,
    keys = {
      { "<F2>", ":Stdheader<CR>", desc = "Insert 42 header" },
    },
  },

  -- Norminette 체크
  {
    "alexandregv/norminette-vim",
    ft = "c",
  },
}
