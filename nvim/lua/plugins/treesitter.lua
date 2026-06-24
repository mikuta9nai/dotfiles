-- ==========================================
-- Treesitter (구문 분석 기반 하이라이팅)
-- ==========================================
-- 정규식 기반보다 정확한 하이라이팅과 코드 구조 인식을 제공합니다.
-- master 브랜치(안정판)를 사용합니다.

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- 사용 언어 + 설정 파일에 필요한 파서
      ensure_installed = {
        "c", "cpp", "rust", "python",
        "lua", "vim", "vimdoc", "query",
        "markdown", "bash",
      },

      -- 파서가 없으면 진입 시 자동 설치
      auto_install = true,

      -- 구문 하이라이팅
      highlight = { enable = true },

      -- [주의] 들여쓰기는 C에서 42 Norminette(hard tab) 규칙과
      -- 충돌할 수 있어 비활성화합니다. 필요하면 enable = true 로 변경.
      indent = { enable = false },
    })
  end,
}
