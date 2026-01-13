return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				markdown = { "prettier" },
				go = { "goimports" },
			},

			-- ✅ Use built-in format_on_save instead of a manual autocmd
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},
		})

		-- Manual format keymap
		vim.keymap.set("n", "<leader>fg", function()
			conform.format({ async = true, lsp_fallback = true })
		end, { desc = "Format buffer" })
	end,
}
