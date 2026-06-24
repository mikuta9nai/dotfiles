-- ==========================================
-- Telescope (파일 탐색 / 검색)
-- ==========================================
-- 컨벤션: p* = project (네 <leader>pv netrw 와 한 묶음)
--   "프로젝트에서 뭔가 찾는다 → <leader>p + 한 글자"

return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",  -- C 컴파일러 필요 (정렬 속도 향상)
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      { "<leader>pf", desc = "Project: find files" },
      { "<C-p>",      desc = "Project: git files" },
      { "<leader>ps", desc = "Project: grep string (prompt)" },
      { "<leader>pg", desc = "Project: live grep" },
      { "<leader>pb", desc = "Project: buffers" },
      { "<leader>pr", desc = "Project: recent files" },
      { "<leader>vh", desc = "Help tags" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      -- ripgrep 유무 자동 감지. 환경을 감지해 분기하는 게 아니라,
      -- "있으면 rg(빠름), 없으면 시스템 grep" 으로 알아서 폴백한다.
      -- → 42 클러스터/낯선 SSH 박스에서 아무것도 설치 안 해도 grep 검색이 동작.
      local has_rg = vim.fn.executable("rg") == 1
      local vimgrep_arguments = has_rg and {
        "rg", "--color=never", "--no-heading", "--with-filename",
        "--line-number", "--column", "--smart-case",
      } or {
        -- GNU grep 폴백: FILE 인자 없이 -r 이면 현재 디렉토리를 검색
        "grep", "--color=never", "--with-filename", "--line-number",
        "--recursive", "--no-messages", "--binary-files=without-match",
        "--extended-regexp",
      }

      telescope.setup({
        defaults = {
          vimgrep_arguments = vimgrep_arguments,
          prompt_prefix = "   ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
          layout_config = {
            horizontal = { preview_width = 0.55, width = 0.87, height = 0.80 },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")

      local map = function(key, fn, desc)
        vim.keymap.set("n", key, fn, { desc = desc })
      end

      -- 파일 찾기
      map("<leader>pf", builtin.find_files, "Project: find files")
      map("<C-p>",      builtin.git_files,  "Project: git files")

      -- 텍스트 검색
      -- ps: 단어를 한 번 입력받아 그 고정 문자열을 전체 검색 (프라임 시그니처)
      map("<leader>ps", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, "Project: grep string (prompt)")
      -- pg: 타이핑하는 대로 실시간 검색
      map("<leader>pg", builtin.live_grep, "Project: live grep")

      -- 버퍼 / 최근 파일 / 도움말
      map("<leader>pb", builtin.buffers,   "Project: buffers")
      map("<leader>pr", builtin.oldfiles,  "Project: recent files")
      map("<leader>vh", builtin.help_tags, "Help tags")
    end,
  },
}
