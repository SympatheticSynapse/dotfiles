return {
	-- Mason: LSP server installer
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},

	-- Mason-lspconfig: Bridge between mason and lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp", -- For LSP capabilities
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Setup keybindings on LSP attach
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gr", function()
					vim.lsp.buf.references()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Reference" }))
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Definition" }))
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Workspace Symbol" }))
				vim.keymap.set("n", "<leader>vd", function()
					vim.diagnostic.setloclist()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Show Diagnostics" }))
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" }))
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" }))
				vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))
				vim.keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP References" }))
				vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
			end

			-- Setup capabilities for autocompletion
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Configure mason-lspconfig
			require("mason-lspconfig").setup({
				ensure_installed = {
					"eslint",
					"lua_ls",
					"jsonls",
					"dockerls",
					"bashls",
					"gopls",
				},
				handlers = {
					-- Default handler for all servers
					function(server_name)
						lspconfig[server_name].setup({
							on_attach = on_attach,
							capabilities = capabilities,
						})
					end,
					-- Custom handler for lua_ls
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										library = vim.api.nvim_get_runtime_file("", true),
										checkThirdParty = false,
									},
									telemetry = {
										enable = false,
									},
								},
							},
						})
					end,
				},
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Helper functions for super tab behavior
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			-- `/` cmdline setup
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			-- Main completion setup
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
					{ name = "path" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					-- LuaSnip jump forward
					["<C-f>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- LuaSnip jump backward
					["<C-b>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Super Tab (expand or jump or select next)
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Shift Tab (select previous or jump back)
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
			})
		end,
	},

	-- LuaSnip
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
	},

	-- Friendly snippets
	{
		"rafamadriz/friendly-snippets",
	},
}
