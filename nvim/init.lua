-- =========================================
-- Минималистичный Neovim с LSP и автокомплит
-- =========================================
-- Enhanced custom colorscheme with more diverse text colors
vim.opt.background = 'dark'
vim.opt.termguicolors = true

-- Enable filetype detection and plugins
vim.cmd('filetype plugin indent on')

-- Set termguicolors
vim.opt.termguicolors = true
-- Прозрачный фон
vim.cmd [[
hi Normal guibg=NONE ctermbg=NONE
hi NormalFloat guibg=NONE ctermbg=NONE
]]

-- ================================
-- 1. Базовые настройки
-- ================================
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.completeopt = "menu,menuone,noselect"
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "↳ "
-- ================================
-- 2. Установка lazy.nvim
-- ================================
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ================================
-- 3. Плагины
-- ================================
require("lazy").setup({

	-- Терминал
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 15,
				open_mapping = [[<C-\>]],
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				persist_size = true,
				direction = "horizontal",
			})
			vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })
			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
		end,
	},
    {
        "sainnhe/everforest",
        config = function()
        -- Настройки темы
        vim.g.everforest_background = "hard"        -- hard, medium, soft
        vim.g.everforest_transparent_background = 1
        vim.g.everforest_better_performance = 1
        -- Подключаем тему
        vim.cmd([[colorscheme everforest]])
        end,
  },

	-- Mason
	{
		"williamboman/mason.nvim",
		config = function() require("mason").setup() end
	},

	-- Mason + LSP
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		config = function()
			require("mason-lspconfig").setup {
				ensure_installed = { "pylsp", "clangd", "gopls", "lua_ls" }
			}
		end
	},

	-- LSP
	{ "neovim/nvim-lspconfig" },

	-- Автодополнение
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip"
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
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "luasnip" },
				},
			})
		end,
	},

	-- Tree-sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = { "python", "c", "cpp", "go", "lua", "html", "css", "javascript", "typescript" },
				highlight = { enable = true },
				indent = { enable = true },
			}
		end
	},

	-- Файловый менеджер
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				filters = { dotfiles = true }
			})
			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
		end,
	},

	-- Статус-бар
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
			})
		end,
	},

	-- Вкладки
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					numbers = "none",
					diagnostics = "nvim_lsp",
					separator_style = "slant",
					show_buffer_close_icons = true,
					show_close_icon = false,
				},
			})
			vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<C-t>", ":bdelete<CR>", { noremap = true, silent = true })
		end,
	},

	-- Git
	{ "tpope/vim-fugitive", cmd = { "Git", "G" } },
})

-- ================================
-- 4. Настройка LSP (новый API)
-- ================================
-- Общий конфиг для всех серверов
vim.lsp.config("*", {
	on_attach = function(_, bufnr)
		local opts = { noremap=true, silent=true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Индивидуально для Python через pylsp
vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				pyflakes = { enabled = true },
				pycodestyle = { enabled = true },
				mccabe = { enabled = true },
				pylsp_mypy = { enabled = true },   -- проверка типов
				yapf = { enabled = false },
			}
		}
	}
})

-- Включаем сервер
vim.lsp.enable({ "pylsp", "clangd", "gopls", "lua_ls" })

