-- =========================================
-- Минималистичный Neovim с LSP и автокомплит
-- =========================================
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
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.completeopt = "menu,menuone,noselect"

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
-- 3. Настройка LSP и автокомплита
-- ================================
require("lazy").setup({
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 15, -- размер окна терминала (в строках, если горизонтально)
				open_mapping = [[<C-\>]], -- горячая клавиша (Ctrl+\)
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				persist_size = true,
				start_in_insert = true,
				direction = "horizontal", -- варианты: horizontal | vertical | tab | float
			})

			-- Доп. хоткеи
			vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })
			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true }) -- выйти в normal mode из терминала
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function() require("mason").setup() end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		config = function()
			require("mason-lspconfig").setup {
				ensure_installed = { "pylsp", "clangd", "gopls", "lua_ls" }
			}
		end
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local on_attach = function(_, bufnr)
				local opts = { noremap=true, silent=true }
				vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
			end

			local servers = { "pylsp", "clangd", "gopls", "lua_ls" }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup { on_attach = on_attach }
			end
		end
	},
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

	-- ================================
	-- Tree-sitter
	-- ================================
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = { "python", "c", "cpp", "go", "lua", "html", "css", "javascript", "typescript" },
				highlight = { enable = true },
				indent = { enable = true },
			}
		end
	},

	-- ================================
	-- Файловый менеджер
	-- ================================
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- иконки (по желанию)
		config = function()
			-- Загружаем сам плагин
			require("nvim-tree").setup {}
			dotfiles = true, 
			-- Горячая клавиша Ctrl+n
			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
		end,
	},
	-- ================================
	-- Статус-бар
	-- ================================
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",  -- здесь меняешь тему
					icons_enabled = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers", -- показываем буферы как вкладки
					numbers = "none",
					diagnostics = "nvim_lsp",
					separator_style = "slant",
					show_buffer_close_icons = true,
					show_close_icon = false,
				},
			})

			-- Горячие клавиши для переключения вкладок
			vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

			-- 🔹 Горячая клавиша для закрытия вкладки
			vim.keymap.set("n", "<C-t>", ":bdelete<CR>", { noremap = true, silent = true })
		end,
	},	-- ================================
	-- Git
	-- ================================
	{ "tpope/vim-fugitive", cmd = { "Git", "G" } },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
		 transparent = true,
		 styles = { sidebars = "transparent", floats = "transparent" },
		},
		config = function(_, opts)
		 require("tokyonight").setup(opts)
		 vim.cmd([[colorscheme tokyonight]])
		end,
	},
})

