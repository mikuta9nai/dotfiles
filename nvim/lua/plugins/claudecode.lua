-- ==========================================
-- Claude Code (coder/claudecode.nvim)
-- ==========================================
-- Neovim 안에서 Claude Code CLI와 WebSocket(MCP)으로 연동.
-- VS Code/JetBrains 확장과 동일한 프로토콜을 순수 Lua로 구현.
-- 사전 요구사항: claude CLI 설치 (PATH에 있어야 함)
--
-- snacks.nvim 미설치 → 터미널은 native provider 사용.
-- 키맵 프리픽스: <leader>c (c = claude/code)
--   <leader>a 는 harpoon이 쓰므로 의도적으로 피함.

return {
  "coder/claudecode.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("claudecode").setup({
      terminal = { provider = "native" },  -- snacks 없으므로 내장 터미널 사용
    })
  end,
  -- keys 로 지연 로딩: 아래 키를 처음 누를 때 플러그인 로드
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>",          desc = "Claude: toggle" },
    { "<leader>cF", "<cmd>ClaudeCodeFocus<cr>",     desc = "Claude: focus" },
    { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Claude: resume" },
    { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude: continue" },

    -- 현재 버퍼를 컨텍스트로 추가
    { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>",     desc = "Claude: add buffer" },

    -- 선택 영역을 Claude로 전송 (비주얼 모드)
    { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: send selection" },

    -- 파일 트리(netrw/neo-tree/oil 등)에서 선택 파일 추가
    { "<leader>ct", "<cmd>ClaudeCodeTreeAdd<cr>",   desc = "Claude: add tree file" },

    -- diff 제안 수락 / 거부
    { "<leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
    { "<leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Claude: deny diff" },
  },
}
