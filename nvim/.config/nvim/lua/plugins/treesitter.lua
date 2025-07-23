return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        'dockerfile',
        'go',
        'helm',
        'html',
        'jq',
        'json',
        'lua',
        'make',
        'markdown_inline',
        'python',
        'regex',
        'sql',
        'terraform',
        'typescript',
        'tmux',
        'yaml'
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
