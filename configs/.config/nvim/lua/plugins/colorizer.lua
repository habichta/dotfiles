require 'colorizer'.setup {
  '*',                                                      -- Highlight all files, but customize some others.
  css = { rgb_fn = true, RRGGBBAA = true, hsl_fn = true },  -- Enable parsing rgb(...) functions in css.
  scss = { rgb_fn = true, RRGGBBAA = true, hsl_fn = true }, -- Enable parsing rgb(...) functions in css.
  html = { names = false, },                                -- Disable parsing "names" like Blue or Gray
  '!vim',                                                   -- Exclude vim from highlighting.
}
