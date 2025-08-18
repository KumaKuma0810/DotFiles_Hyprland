local lazypath = vim.fn.stdpath("data") .. "/site/pack/lazy/start/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Настройка pylsp
      require('lspconfig').pylsp.setup{
        -- Здесь можно добавить настройки сервера, если нужно
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = true },
              pycodestyle = { enabled = true },
              -- Другие плагины можно настроить здесь
            }
          }
        }
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            -- можно добавить сниппеты, например luasnip
          end,
        },
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    'goolord/alpha-nvim',
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Здесь можно кастомизировать ASCII арт, я оставил твой оригинальный
      dashboard.section.header.val = {
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠓⠶⣤⠀⠀⠀⠀⣠⠶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠇⠀⢠⡏⠀⠀⢀⡔⠉⠀⢈⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠩⠤⣄⣼⠁⠀⣠⠟⠀⠀⣠⠏⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠁⠀⠀⠣⣤⣀⡼⠃⠀⢀⡴⠋⠈⠳⡄⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⣿⡿⠿⠿⠟⠛⠛⠛⠛⠿⠿⣿⣿⣶⣤⣄⠀⠀⠀⠉⠀⢀⡴⠋⠀⠀⣠⠞⠁⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⠿⠋⠉⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠻⢿⣿⣶⣄⠀⠀⠳⣄⠀⣠⠞⢁⡠⢶⡄⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⠿⠋⠀⠀⢀⣴⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢤⡈⠛⢿⣿⣦⡀⠈⠛⢡⠚⠃⠀⠀⢹⡆⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠟⠁⠀⠀⠀⢀⣾⠃⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀⢻⣦⠀⠙⢿⣿⣦⡀⠈⢶⣀⡴⠞⠋⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⣠⣿⡿⠃⠀⠀⠀⠀⢀⣾⡇⢀⡄⠀⢸⡇⠀⠀⠀⠀⠀⠀⣀⠀⢸⣷⡀⠀⠀⠹⣷⡀⠀⠙⢿⣷⡀⠀⠉⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⣰⣿⡟⠀⠀⠀⠀⠀⠀⣾⣿⠃⣼⡇⠀⢸⡇⠀⠀⠀⠀⠀⠀⣿⠀⢸⣿⣷⡀⠀⢀⣾⣿⡤⠐⠊⢻⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⢠⣿⣿⣼⡇⠀⠀⠀⠀⢠⣿⠉⢠⣿⠧⠀⣸⣇⣠⡄⠀⠀⠀⠀⣿⠠⢸⡟⠹⣿⡍⠉⣿⣿⣧⠀⠀⠀⠻⣿⣶⣄⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⢸⣿⣿⡟⠀⠀⠀⠀⠀⣼⡏⢠⡿⣿⣦⣤⣿⡿⣿⡇⠀⠀⠀⢸⡿⠻⣿⣧⣤⣼⣿⡄⢸⡿⣿⡇⠀⠀⢠⣌⠛⢿⣿⣶⣤⣤⣄⡀",
"⠀⠀⠀⣀⣤⣿⣿⠟⣀⠀⠀⠀⠀⠀⣿⢃⣿⠇⢿⣯⣿⣿⣇⣿⠁⠀⠀⠀⣾⡇⢸⣿⠃⠉⠁⠸⣿⣼⡇⢻⡇⠀⠀⠀⢿⣷⣶⣬⣭⣿⣿⣿⠇",
"⣾⣿⣿⣿⣿⣻⣥⣾⡇⠀⠀⠀⠀⠀⣿⣿⠇⠀⠘⠿⠋⠻⠿⠿⠶⠶⠾⠿⠿⠍⢛⣧⣰⠶⢀⣀⣼⣿⣴⡸⣿⠀⠀⠀⠸⣿⣿⣿⠉⠛⠉⠀⠀",
"⠘⠛⠿⠿⢿⣿⠉⣿⠁⠀⠀⠀⠀⢀⣿⡿⣶⣶⣶⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⢀⣭⣶⣿⡿⠟⠋⠉⠀⠀⣿⠀⡀⡀⠀⣿⣿⣿⡆⠀⠀⠀⠀",
"⠀⠀⠀⠀⣼⣿⠀⣿⠀⠀⠸⠀⠀⠸⣿⠇⠀⠀⣈⣩⣭⣿⡿⠟⠃⠀⠀⠀⠀⠀⠙⠛⠛⠛⠛⠻⠿⠷⠆⠀⣯⠀⠇⡇⠀⣿⡏⣿⣧⠀⠀⠀⠀",
"⠀⠀⠀⠀⢿⣿⡀⣿⡆⠀⠀⠀⠀⠀⣿⠰⠿⠿⠛⠋⠉⠀⠀⢀⣴⣶⣶⣶⣶⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⠀⠀⠀⣿⡇⣿⣿⠀⠀⠀⠀",
"⠀⠀⠀⠀⢸⣿⡇⢻⣇⠀⠘⣰⡀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠀⠀⠀⣿⣧⣿⡿⠀⠀⠀⠀",
"⠀⠀⠀⠀⠈⣿⣧⢸⣿⡀⠀⡿⣧⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⣿⡄⠀⠀⠀⣼⡇⠀⠀⠀⠀⠀⠀⢀⣤⣾⡟⢡⣶⠀⢠⣿⣿⣿⠃⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠹⣿⣿⣿⣷⠀⠇⢹⣷⡸⣿⣶⣦⣄⣀⡀⠀⠀⠀⣿⡇⠀⠀⢠⣿⠁⣀⣀⣠⣤⣶⣾⡿⢿⣿⡇⣼⣿⢀⣿⣿⠿⠏⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠈⠛⠛⣿⣷⣴⠀⢹⣿⣿⣿⡟⠿⠿⣿⣿⣿⣿⣾⣷⣶⣿⣿⣿⣿⡿⠿⠟⠛⠋⠉⠀⢸⣿⣿⣿⣿⣾⣿⠃⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣦⣘⣿⡿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠻⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("f", "󰮗  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "󰩈  Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.config)
    end,
  },

  -- Тема
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end
  },

  -- Линия состояния
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          section_separators = '',
          component_separators = '',
        }
      })
    end
  },

  -- Вкладки
  {
    "alvarosevilla95/luatab.nvim",
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require("luatab").setup({
        separator = function() return "▏" end,
        render = function(tab, tabs)
          local win = vim.api.nvim_tabpage_get_win(tab)
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
          local tabnr = vim.api.nvim_tabpage_get_number(tab)
          local active = tab == vim.api.nvim_get_current_tabpage()
          return (active and "●" or "○") .. " " .. tabnr .. ": " .. (bufname ~= "" and bufname or "[No Name]")
        end,
      })
    end,
  },

  -- Комментирование кода
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      require('Comment').setup()
    end,
  },

  -- Парсер синтаксиса
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Терминал внизу
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        size = 10,
        open_mapping = [[<c-t>]],
        direction = "horizontal",
        shade_terminals = true,
        start_in_insert = false,
        auto_scroll = true,
        persist_size = true,
        shell = vim.o.shell,
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup{}

      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
    end,
  },


  -- Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
          side = "right",
          preserve_window_proportions = true,
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
          update_root = false,
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = "name",
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          local opts = function(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
        end,
      })
    end,
  },
})

-- █ [3] Цвета и оформление
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.number = true
vim.o.signcolumn = "yes"

-- █ [4] Базовые настройки редактора
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"  -- чтобы использовать системный буфер обмена
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.splitbelow = true
vim.o.splitright = true

-- Прозрачный фон
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
]]

-- Автосохранение при выходе из режима вставки
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "silent! wall",
})

-- Luatab — кастомные табы с иконками и git-статусом
require("luatab").setup({
  separator = function()
    return "  "
  end,
  render = function(tab, tabs)
    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    local active = tab == vim.api.nvim_get_current_tabpage()

    if filename == "" then filename = "[No Name]" end

    local icon, _ = require("nvim-web-devicons").get_icon(filename, vim.fn.fnamemodify(filename, ":e"), { default = true })

    local git_status = ""
    local gsd = vim.b[buf].gitsigns_status_dict
    if gsd then
      if gsd.added and gsd.added > 0 then git_status = git_status .. "+" end
      if gsd.changed and gsd.changed > 0 then git_status = git_status .. "~" end
      if gsd.removed and gsd.removed > 0 then git_status = git_status .. "-" end
    end

    local hl_group = active and "%#TabLineSel#" or "%#TabLine#"

    return string.format("%s %s %s %s %s", hl_group, icon or "", filename, git_status, hl_group)
  end,
})

-- Хайлайты для табов
vim.cmd [[
  highlight TabLine guibg=NONE guifg=#666666 gui=none
  highlight TabLineSel guibg=#5f87ff guifg=#ffffff gui=bold
  highlight TabLineFill guibg=NONE
]]

-- Горячие клавиши для табов
local map = vim.keymap.set
map("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true })
map("n", "<S-Tab>", ":tabprev<CR>", { noremap = true, silent = true })
map("n", "<Leader>tn", ":tabnew<CR>", { noremap = true, silent = true })
map("n", "<Leader>tc", ":tabclose<CR>", { noremap = true, silent = true })

-- █ [6] Автодополнение (nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
})

-- █ [7] Treesitter (подсветка синтаксиса)
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python" },
  highlight = { enable = true },
})

-- █ [9] Nvim-tree — файловый менеджер
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Автоматическое открытие NvimTree при загрузке, если он не открыт
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local api = require("nvim-tree.api")
    local is_tree_open = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_option(buf, "filetype") == "NvimTree" then
        is_tree_open = true
        break
      end
    end
    if not is_tree_open then
      api.tree.open()
    end
  end,
})

-- Прозрачный фон NvimTree
vim.cmd [[
  highlight NvimTreeNormal guibg=NONE
  highlight NvimTreeNormalNC guibg=NONE
]]

-- █ LSP keybindings
local opts = { noremap = true, silent = true }
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>f", function() vim.lsp.buf.format() end, opts)

-- █ Terminal toggle (toggleterm)
map("n", "<C-t>", function()
  local dir = vim.fn.expand("%:p:h")
  vim.cmd("ToggleTerm dir=" .. dir)
end, { noremap = true, silent = true })

map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- █ Comment.nvim — удобное комментирование
map('n', '<a-/>', function() require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true })
map('v', '<a-/>', function() require('Comment.api').toggle.linewise(vim.fn.visualmode()) end, { noremap = true, silent = true })

-- █ Telescope — быстрый поиск
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts)
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)

