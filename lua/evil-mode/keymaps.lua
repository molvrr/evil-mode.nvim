local builtin = require('telescope.builtin')
local between_keys
between_keys = function(terms_before, f, terms_after)
	return function()
		local keys_before = vim.api.nvim_replace_termcodes(terms_before, true, true, true)
		local keys_after = vim.api.nvim_replace_termcodes(terms_after, true, true, true)
		vim.api.nvim_feedkeys(keys_before, 'n', { })
		f()
		return vim.api.nvim_feedkeys(keys_after, 'n', { })
	end
end
local eq_pos
eq_pos = function(a, b)
	return a[1] == b[1] and a[2] == b[2]
end
local sort_pos
sort_pos = function(a, b)
	if a[1] < b[1] then
		return {
			a,
			b
		}
	end
	if a[1] > b[1] then
		return {
			b,
			a
		}
	end
	if a[2] < b[2] then
		return {
			a,
			b
		}
	end
	return {
		b,
		a
	}
end
local edges = {
	start = 1,
	["end"] = 2
}
local selection_edge_mover
selection_edge_mover = function(edge)
	return function()
		local pos_a = vim.fn.getcharpos('v')
		local pos_b = vim.fn.getcharpos('.')
		pos_a = {
			pos_a[2],
			pos_a[3]
		}
		pos_b = {
			pos_b[2],
			pos_b[3]
		}
		local pos_start, pos_end = unpack(sort_pos(pos_a, pos_b))
		local cursor = vim.api.nvim_win_get_cursor(0)
		local on_start = eq_pos(pos_start, {
			cursor[1],
			cursor[2] + 1
		})
		local on_end = eq_pos(pos_end, {
			cursor[1],
			cursor[2] + 1
		})
		local already_there = (edge == edges.start and on_start) or (edge == edges.ending and on_end)
		if not already_there then
			return vim.fn.feedkeys('o', 'n')
		end
	end
end
local selection_start = selection_edge_mover(edges.start)
local selection_end = selection_edge_mover(edges["end"])
vim.keymap.set('n', '<S-Up>', 'v<Up>')
vim.keymap.set('n', '<S-Down>', 'v<Down>')
vim.keymap.set('n', '<S-Left>', 'v<Left>')
vim.keymap.set('n', '<S-Right>', 'v<Right>')
vim.keymap.set('n', '<C-S-Left>', 'vb')
vim.keymap.set('n', '<C-S-Right>', 'vw')
vim.keymap.set('i', '<C-S-Left>', '<ESC>vb')
vim.keymap.set('i', '<C-S-Right>', '<ESC><Right>vw')
vim.keymap.set('v', '<S-Up>', '<Up>')
vim.keymap.set('v', '<S-Down>', '<Down>')
vim.keymap.set('v', '<S-Left>', '<Left>')
vim.keymap.set('v', '<S-Right>', '<Right>')
vim.keymap.set('v', '<Right>', between_keys("", selection_end, "<Esc>i<Right>"))
vim.keymap.set('v', '<Left>', between_keys("", selection_start, "<Esc>i"))
vim.keymap.set('v', '<Down>', between_keys("", election_end, "<Esc>i<Right>"))
vim.keymap.set('v', '<Up>', between_keys("", selection_start, "<Esc>i"))
vim.keymap.set('i', '<S-Up>', '<Esc>v<Up>')
vim.keymap.set('i', '<S-Down>', '<Esc>v<Down>')
vim.keymap.set('i', '<S-Left>', '<Esc>v')
vim.keymap.set('i', '<S-Right>', '<Right><Esc>v')
vim.keymap.set({
	'i',
	'v'
}, '<C-s>', '<Esc>:w<CR>i')
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', '<C-v>', 'pi')
vim.keymap.set('i', '<C-v>', '<Esc>pi')
vim.keymap.set('v', '<C-c>', 'y')
vim.keymap.set('v', '<C-x>', 'd<Esc>i')
vim.keymap.set('v', '<BS>', '"_d<Esc>i')
vim.keymap.set('v', '<Del>', '"_d<Esc>i')
vim.keymap.set('n', '<BS>', 'i<BS>')
vim.keymap.set('n', '<Del>', 'i<Del>')
vim.keymap.set('i', '<C-z>', '<Esc>ui')
vim.keymap.set({
	'i',
	'v',
	'n'
}, '<C-p>', builtin.find_files)
vim.keymap.set('n', '<C-S-e>', "<CMD>Oil<CR>", {
	desc = "Open parent directory"
})
return vim.keymap.set('i', '<C-S-e>', "<Esc><CMD>Oil<CR>", {
	desc = "Open parent directory"
})
