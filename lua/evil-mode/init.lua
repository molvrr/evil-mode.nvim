return {
	setup = function(_opts)
		local keymaps = require('evil-mode.keymaps')
		local options = require('evil-mode.options')
		return vim.api.nvim_create_autocmd('BufEnter', {
			callback = function(_e)
				if vim.fn.mode() == 'n' then
					return vim.api.nvim_feedkeys('i', 'n', { })
				end
			end,
			pattern = '*.*'
		})
	end
}
