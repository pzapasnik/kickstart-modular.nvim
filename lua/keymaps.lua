-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Save and quit with leader key
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = '#vim save' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '#vim quit' })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { desc = '#vim quit without save' })
vim.keymap.set('n', '<leader>wq', ':wq<CR>', { desc = '#vim save & quit' })
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, desc = '#vim quit insert mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_next()
end, { remap = false, desc = '#diagnostic Go to next diagnostic' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_prev()
end, { remap = false, desc = '#diagnostic Go to previouse diagnostic' })
vim.keymap.set('n', 'de', vim.diagnostic.open_float, { desc = '#diagnostic Show diagnostic [E]rror messages' })
vim.keymap.set('n', 'dq', vim.diagnostic.setloclist, { desc = '#diagnostic Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
vim.keymap.set('t', '<leader>q', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

--Navigation
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = '#navigation EX file mode' })

--  Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = '#navigation Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = '#navigation Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = '#navigation Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = '#navigation Move focus to the upper window' })

-- quickfix list navigation
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>zz', { desc = '#navigation Navigate to the next quickfix list item' })
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>zz', { desc = '#navigation Navigate to the previeus quickfix list item' })

-- Moving lines vertically in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = '#vim move one line bottom' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = '#vim move one line top' })

-- Sqashing lines below
vim.keymap.set('n', 'J', 'mzJ`z', { desc = '#vim join this line and line below it' })

-- Center cursor after Scroll and search
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = '#vim Scroll down half a page and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = '#vim Scroll up half a page and center cursor' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = '#vim Repeat search forward and center cursor' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = '#vim Repeat search backward and center cursor' })

-- Edition in visual mode
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '#vim  Put yanked text before cursor in visual mode' })

-- yank filepath
vim.keymap.set('n', '<leader>yp', ':let @+ = expand("%")<CR>', { desc = '#vim #yank put current file path to clipboard' })

-- Clear Delete without yanking
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = '#vim Delete selected text or current line without yanking it' })

-- tmux
-- if not work go to plungins/cmp and change the keymap
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = '#tmux Open new mutex window with project workspaces' })

-- substitusion
vim.keymap.set(
  'n',
  '<leader>s',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = '#vim Start a substitution command pre-filled with the word under cursor' }
)

-- add chmod +x to current file
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = '#bash Make the current file executable' })

--spell
vim.keymap.set('n', '<leader>zr', '<cmd>spellr<CR>', { desc = '#Spell repeat all misspaling like last one' })

-- text manipulations
vim.keymap.set('n', '<leader>fn', ':s/\\\\n/\\r/g<CR>', { desc = '#Text normalize line endings' })
vim.keymap.set('v', '<leader>fn', ':%s/\\\\n/\\r/g<CR>', { desc = '#Text normalize line endings' })

--json
vim.api.nvim_set_keymap(
  'n',
  '<leader>de',
  '0y/"{<cr>:g!/^<c-r>0/d<cr>0d/"{<cr>x$x%:%s/\\\\\\\\\\\\"/\\\\\\\\"/g<cr>:s/\\\\"/"/g<cr>:%!jq .<cr>',
  { noremap = true, desc = '#json #mimir normalize graph json' }
)

local json_to_paths_format_command =
  [[jq -r 'paths(scalars) as $p | "\($p | join(".")): \((getpath($p) | tostring))"' | awk '{gsub(/\[[0-9]+\]\./, "."); print}']]

-- Normal mode mapping (whole buffer)
vim.keymap.set(
  'n',
  '<leader>fp',
  string.format(':%%!%s<CR>', json_to_paths_format_command),
  { noremap = true, silent = true, desc = '#Json #Text format json to paths' }
)

-- Visual mode mapping (selected text only)
vim.keymap.set(
  'v',
  '<leader>fp',
  string.format(':!%s<CR>', json_to_paths_format_command),
  { noremap = true, silent = true, desc = '#Json #Text format json to paths' }
)

-- golang wsl linter
vim.api.nvim_set_keymap('n', '<leader>lw', ':!wsl -fix %<cr>', { noremap = true, silent = true, desc = '#golang fix white spaces' })

-- some prime hacks
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disable Q key mapping' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Delete entries from the quickfix / location list with `dd` (and `d` in visual mode)
local function qf_delete(start_line, end_line)
  local win = vim.api.nvim_get_current_win()
  local is_loc = vim.fn.getwininfo(win)[1].loclist == 1

  local what = { items = 0, title = 0, id = 0 }
  local list = is_loc and vim.fn.getloclist(win, what) or vim.fn.getqflist(what)
  local items = list.items

  if #items == 0 then
    return
  end

  start_line = math.max(start_line, 1)
  end_line = math.min(end_line, #items)

  for i = end_line, start_line, -1 do
    table.remove(items, i)
  end

  local set = function(action, what_)
    if is_loc then
      vim.fn.setloclist(win, {}, action, what_)
    else
      vim.fn.setqflist({}, action, what_)
    end
  end

  -- action ' ' pushes a NEW list onto the quickfix stack, so `:colder` undoes the deletion
  set(' ', { title = list.title })

  -- `quickfixtextfunc` is a funcref, and funcrefs reach Lua as `vim.NIL`, so a custom
  -- formatter has to be carried over from the old list (found by id) in Vimscript.
  -- It must be in place before the items land, or the window renders with the default format.
  local getter = is_loc and string.format('getloclist(%d, ', win) or 'getqflist('
  local setter = is_loc and string.format('setloclist(%d, ', win) or 'setqflist('
  vim.cmd(string.format(
    [[
      let g:QfDeleteTextfunc = %s{'id': %d, 'quickfixtextfunc': 0}).quickfixtextfunc
      if !empty(g:QfDeleteTextfunc)
        call %s[], 'r', {'quickfixtextfunc': g:QfDeleteTextfunc})
      endif
      unlet g:QfDeleteTextfunc
    ]],
    getter,
    list.id,
    setter
  ))

  set('r', { items = items })

  -- keep the cursor where the deleted entry was
  if #items > 0 then
    pcall(vim.api.nvim_win_set_cursor, win, { math.min(start_line, #items), 0 })
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  desc = 'Quickfix list editing keymaps',
  group = vim.api.nvim_create_augroup('kickstart-quickfix', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set('n', 'dd', function()
      local line = vim.fn.line '.'
      qf_delete(line, line + vim.v.count1 - 1)
    end, vim.tbl_extend('force', opts, { desc = '#quickfix Delete entry (accepts a count)' }))

    vim.keymap.set('x', 'd', function()
      local first = vim.fn.line 'v'
      local last = vim.fn.line '.'
      vim.cmd 'normal! \27' -- leave visual mode
      qf_delete(math.min(first, last), math.max(first, last))
    end, vim.tbl_extend('force', opts, { desc = '#quickfix Delete selected entries' }))

    local is_loc = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1

    vim.keymap.set('n', 'u', function()
      local ok = pcall(vim.cmd, is_loc and 'lolder' or 'colder')
      if not ok then
        vim.notify('Quickfix: nothing to undo', vim.log.levels.WARN)
      end
    end, vim.tbl_extend('force', opts, { desc = '#quickfix Undo (older list)' }))

    vim.keymap.set('n', '<C-r>', function()
      local ok = pcall(vim.cmd, is_loc and 'lnewer' or 'cnewer')
      if not ok then
        vim.notify('Quickfix: nothing to redo', vim.log.levels.WARN)
      end
    end, vim.tbl_extend('force', opts, { desc = '#quickfix Redo (newer list)' }))
  end,
})

-- vim: ts=2 sts=2 sw=2 et
