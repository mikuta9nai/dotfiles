-- ==========================================
-- LSP & 자동완성 (Mason + lspconfig + nvim-cmp)
-- ==========================================
-- Neovim 0.11+ / mason-lspconfig 2.x 기준.
-- 구버전의 mason-lspconfig `handlers` 옵션은 2.x에서 제거되었으므로
-- 새로운 vim.lsp.config() / vim.lsp.enable() 방식을 사용합니다.

return {
  -- Mason: LSP 서버 설치 관리
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  -- Mason ↔ lspconfig 연결 + LSP 키맵
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- [1] 모든 LSP 서버에 공통 capabilities 적용 (전역 기본값)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- [2] 서버별 추가 설정 (전역 기본값에 병합됨)
      -- Lua: Neovim 설정을 편집할 때 'vim' 전역 변수를 인식시킴
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- C/C++: clangd. 헤더 자동완성 및 background indexing
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })

      -- [3] 설치할 서버 목록.
      -- mason-lspconfig 2.x는 ensure_installed 된 서버를 자동으로 활성화함.
      require("mason-lspconfig").setup({
        -- pyright 는 npm(Node) 의존이라 42 환경에서 설치가 어려움.
        -- pip 기반 jedi-language-server 를 사용 (정의 이동/자동완성 우수).
        ensure_installed = {
          "clangd",                 -- C / C++
          "jedi_language_server",   -- Python (pip 기반)
          "rust_analyzer",          -- Rust
          "lua_ls",                 -- Lua (Neovim 설정용)
        },
      })

      -- [4] LSP 연결 시 키맵 등록 (ThePrimeagen 스타일)
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keymaps",
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local function o(desc) return vim.tbl_extend("force", opts, { desc = desc }) end

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, o("Go to definition"))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, o("Hover info"))
          vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, o("Line diagnostics"))
          vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, o("Code action"))
          vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, o("Find references"))
          vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, o("Rename symbol"))
          vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, o("Workspace symbol"))
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, o("Signature help"))

          -- 진단 이동 (vim 관례: [ = 이전, ] = 다음). 0.11+ jump API
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, o("Prev diagnostic"))
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, o("Next diagnostic"))
        end,
      })
    end,
  },

  -- 자동완성 엔진 (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",  -- Insert 모드 진입 시 로드
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",     -- 버퍼 단어 완성
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Tab: 확정 or 스니펫 점프
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift+Tab: 위로 이동 or 스니펫 역방향
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- 목록 이동 (화살표 / Ctrl)
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
