-- Plugin usage statistics.
-- Records which Ex commands and leader mappings you actually invoke, so you can
-- tell which plugins are earning their startup cost.  Never records insert-mode
-- or cmdline text -- only command names and leader key sequences.
--
--   :UsageReport   ranked report, attributed to plugins
--   :UsageUnused   plugins with zero recorded use
--   :UsageReset    wipe the log

local M = {}

local logfile = vim.fn.stdpath('state') .. '/plugin-usage.jsonl'
local buffered = {}

-- Which plugin owns a command / leader mapping.  Only entries worth tracking;
-- anything unlisted is reported under "(builtin/unattributed)".
local OWNER = {
  -- commands
  Black = 'coc (pyright)', Isort = 'coc (pyright)', Format = 'coc (pyright)',
  MarkdownPreview = 'markdown-preview.nvim', MarkdownPreviewToggle = 'markdown-preview.nvim',
  Obsess = 'vim-obsession',
  GFiles = 'fzf.vim', Files = 'fzf.vim', Buffers = 'fzf.vim', History = 'fzf.vim',
  Tags = 'fzf.vim', Rg = 'fzf.vim', BuffersDelete = 'fzf.vim',
  Bdelete = 'bufdelete.nvim', Bwipeout = 'bufdelete.nvim',
  Startify = 'vim-startify', SLoad = 'vim-startify', SSave = 'vim-startify',
  Gitsigns = 'gitsigns.nvim',
  TestNearest = 'vim-test', TestFile = 'vim-test', TestSuite = 'vim-test', TestLast = 'vim-test',
  ClaudeCode = 'claude-code.nvim',
  CodeCompanion = 'codecompanion.nvim', CodeCompanionChat = 'codecompanion.nvim',
  CodeCompanionActions = 'codecompanion.nvim',
  Copilot = 'copilot.vim',
  NvimTreeToggle = 'nvim-tree.lua', NvimTreeFindFile = 'nvim-tree.lua', NvimTreeOpen = 'nvim-tree.lua',
  HighlightColors = 'nvim-highlight-colors',
  TSUpdate = 'nvim-treesitter', TSInstall = 'nvim-treesitter',
}
-- fugitive owns bare :G / :Git and friends
for _, c in ipairs({ 'G', 'Git', 'Gdiffsplit', 'Gwrite', 'Gread', 'Gblame', 'Gstatus', 'Glog', 'Gedit' }) do
  OWNER[c] = 'vim-fugitive'
end
-- coc commands
for _, c in ipairs({ 'CocCommand', 'CocList', 'CocAction', 'CocRestart', 'CocInfo', 'CocDiagnostics',
                     'CocConfig', 'CocOutline' }) do
  OWNER[c] = 'coc.nvim'
end

local MAP_OWNER = {
  [',p'] = 'fzf.vim', [',P'] = 'fzf.vim', [',}'] = 'fzf.vim', [',['] = 'fzf.vim',
  [',\\'] = 'fzf.vim', [',]'] = 'fzf.vim', [',o'] = 'fzf.vim', [',O'] = 'fzf.vim',
  [',mf'] = 'coc.nvim', [',mm'] = 'coc.nvim',
  [',0'] = 'vim-obsession', [',9'] = 'vim-obsession',
  [',cb'] = 'bufdelete.nvim',
  [',CC'] = 'claude-code.nvim', [',Cc'] = 'claude-code.nvim', [',Cv'] = 'claude-code.nvim',
  [',k'] = 'vim-interestingwords', [',K'] = 'vim-interestingwords',
}
for _, m in ipairs({ 'hs', 'hr', 'hS', 'hu', 'hR', 'hp', 'hb', 'hd', 'hD', 'tb', 'td' }) do
  MAP_OWNER[',' .. m] = 'gitsigns.nvim'
end

local function record(kind, name)
  buffered[#buffered + 1] = { k = kind, n = name, t = os.time() }
end

local function flush()
  if #buffered == 0 then return end
  local lines = {}
  for _, e in ipairs(buffered) do lines[#lines + 1] = vim.json.encode(e) end
  local fd = io.open(logfile, 'a')
  if fd then
    fd:write(table.concat(lines, '\n') .. '\n')
    fd:close()
  end
  buffered = {}
end

-- ---------------------------------------------------------------- collectors

-- Ex commands: take only the command name, never its arguments.
vim.api.nvim_create_autocmd('CmdlineLeave', {
  callback = function()
    if vim.v.event.abort then return end
    local line = vim.fn.getcmdline()
    if vim.fn.getcmdtype() ~= ':' or not line or line == '' then return end
    local cmd = line:match('^%s*[%%%d,.$+%-%s]*(%a[%w_]*)')
    if cmd then record('cmd', cmd) end
  end,
})

-- Leader sequences.  Only normal/visual/operator-pending -- insert-mode and
-- cmdline keystrokes are never seen by this.
local pending, timer = nil, nil
local LEADERS = { [','] = true, ['\\'] = true }

local function flush_pending()
  if pending and #pending > 1 then record('map', pending) end
  pending = nil
end

vim.on_key(function(_, typed)
  if not typed or typed == '' then return end
  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  if not (mode == 'n' or mode == 'v' or mode == 'V' or mode == '\22' or mode == 'o') then
    pending = nil
    return
  end
  if pending then
    -- ':' or <Esc> means the mapping already fired and we are seeing its rhs
    if typed == ':' or typed == '\27' then
      flush_pending()
      return
    end
    pending = pending .. typed
    if #pending >= 4 then flush_pending() end
  elseif LEADERS[typed] then
    pending = typed
  else
    return
  end
  if timer then timer:stop() end
  timer = vim.defer_fn(flush_pending, 250)
end)

-- Filetypes actually edited -- tells you which coc extensions / ftplugins matter.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(a)
    if a.match and a.match ~= '' then record('ft', a.match) end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', { callback = flush })

-- ------------------------------------------------------------------ reporting

local function load_events()
  local events, fd = {}, io.open(logfile, 'r')
  if not fd then return events end
  for line in fd:lines() do
    local ok, e = pcall(vim.json.decode, line)
    if ok and e then events[#events + 1] = e end
  end
  fd:close()
  return events
end

local function owner_of(e)
  if e.k == 'cmd' then return OWNER[e.n] end
  if e.k == 'map' then
    -- try longest prefix first: ',hs' before ',h'
    for len = #e.n, 2, -1 do
      local o = MAP_OWNER[e.n:sub(1, len)]
      if o then return o end
    end
  end
  return nil
end

function M.report()
  flush()
  local events = load_events()
  if #events == 0 then
    return vim.notify('No usage recorded yet. Log: ' .. logfile, vim.log.levels.WARN)
  end

  local by_plugin, by_cmd, by_map, by_ft = {}, {}, {}, {}
  local first = events[1].t
  for _, e in ipairs(events) do
    if e.t < first then first = e.t end
    local tgt = e.k == 'cmd' and by_cmd or e.k == 'map' and by_map or by_ft
    tgt[e.n] = (tgt[e.n] or 0) + 1
    local o = owner_of(e)
    if o then by_plugin[o] = (by_plugin[o] or 0) + 1 end
  end

  local function ranked(t)
    local r = {}
    for k, v in pairs(t) do r[#r + 1] = { k, v } end
    table.sort(r, function(a, b) return a[2] > b[2] end)
    return r
  end

  local days = math.max(1, math.floor((os.time() - first) / 86400))
  local out = {
    ('Plugin usage over %d day(s), %d events'):format(days, #events),
    ('log: %s'):format(logfile),
    '',
    '── by plugin ────────────────────────────',
  }
  for _, r in ipairs(ranked(by_plugin)) do
    out[#out + 1] = ('  %5d  %s'):format(r[2], r[1])
  end
  local sections = {
    { 'commands',    by_cmd, 25 },
    { 'leader maps', by_map, 20 },
    { 'filetypes',   by_ft,  15 },
  }
  for _, sec in ipairs(sections) do
    local label, tbl, n = sec[1], sec[2], sec[3]
    out[#out + 1] = ''
    out[#out + 1] = ('── %s ────────────────────────────'):format(label)
    local r = ranked(tbl)
    for i = 1, math.min(#r, n) do out[#out + 1] = ('  %5d  %s'):format(r[i][2], r[i][1]) end
  end

  vim.cmd('vnew')
  vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile = 'nofile', 'wipe', false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
end

function M.unused()
  flush()
  local used = {}
  for _, e in ipairs(load_events()) do
    local o = owner_of(e)
    if o then used[o] = true end
  end
  local all = {}
  for _, o in pairs(OWNER) do all[o] = true end
  for _, o in pairs(MAP_OWNER) do all[o] = true end

  local out = { 'Trackable plugins with ZERO recorded use:', '' }
  local names = {}
  for o in pairs(all) do if not used[o] then names[#names + 1] = o end end
  table.sort(names)
  for _, n in ipairs(names) do out[#out + 1] = '  ' .. n end
  out[#out + 1] = ''
  out[#out + 1] = '(Plugins that work passively -- gitsigns signs, lualine, treesitter,'
  out[#out + 1] = ' indent-blankline, gruvbox, devicons -- will not appear as "used" here.)'
  vim.notify(table.concat(out, '\n'))
end

vim.api.nvim_create_user_command('UsageReport', M.report, {})
vim.api.nvim_create_user_command('UsageUnused', M.unused, {})
vim.api.nvim_create_user_command('UsageReset', function()
  buffered = {}
  os.remove(logfile)
  vim.notify('usage log cleared')
end, {})

return M
