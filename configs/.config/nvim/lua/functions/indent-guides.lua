-- Indent guides using builtin 'listchars', replacing indent-blankline.nvim.
--
-- 'leadmultispace' repeats its pattern across leading whitespace, so the pattern
-- has to be exactly as wide as one indent level -- otherwise the bars drift out
-- of alignment with the code.  Indent width is per-buffer here: the .vimrc sets
-- shiftwidth=2, but nvim's own python ftplugin overrides it to 4, and other
-- ftplugins differ again.  So derive it from the buffer instead of hardcoding.

local BAR = '▎'

local function set_indent_guides()
  -- 'shiftwidth' of 0 means "follow tabstop"
  local width = vim.bo.shiftwidth
  if width == 0 then width = vim.bo.tabstop end
  if width < 1 then return end

  -- Guides only make sense when indentation is spaces; with real tabs the
  -- existing 'tab:' listchars entry already marks them.
  if not vim.bo.expandtab then
    vim.opt_local.listchars:remove('leadmultispace')
    return
  end

  vim.opt_local.listchars:append({ leadmultispace = BAR .. string.rep(' ', width - 1) })
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType' }, {
  group = vim.api.nvim_create_augroup('IndentGuides', { clear = true }),
  callback = set_indent_guides,
})

-- Keep the guides aligned if indent settings change mid-session (e.g. :set sw=2)
vim.api.nvim_create_autocmd('OptionSet', {
  group = 'IndentGuides',
  pattern = { 'shiftwidth', 'tabstop', 'expandtab' },
  callback = set_indent_guides,
})
