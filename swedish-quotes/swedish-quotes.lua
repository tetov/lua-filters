-- lua filter for spell checking: requires 'aspell'.
-- (C) 2017 John MacFarlane, released under MIT license

local text = require('text')
local M = {}
local deflang


local function get_deflang(meta)
  deflang = (meta.lang and pandoc.utils.stringify(meta.lang)) or 'en'
  return {} -- eliminate meta so it doesn't get spellchecked
end

function M.quotes()
    return pandoc.Str '”'
end

local function run_spellcheck(lang)
  local keys = {}
  local wordlist = words[lang]
  for k,_ in pairs(wordlist) do
    keys[#keys + 1] = k
  end
  local inp = table.concat(keys, '\n')
  local outp = pandoc.pipe('aspell', {'list','-l',lang}, inp)
  for w in string.gmatch(outp, "(%a*)\n") do
    io.write(w)
    if lang ~= deflang then
      io.write("\t[" .. lang .. "]")
    end
    io.write("\n")
  end
end

local function results(el)
    pandoc.walk_block(pandoc.Div(el.blocks), {Str = function(e) add_to_dict(deflang, e.text) end})
    for lang,v in pairs(words) do
        run_spellcheck(lang)
    end
    os.exit(0)
end

local function checkstr(el)
  add_to_dict(deflang, el.text)
end

local function checkspan(el)
  local lang = el.attributes.lang
  if not lang then return nil end
  pandoc.walk_inline(el, {Str = function(e) add_to_dict(lang, e.text) end})
  return {} -- remove span, so it doesn't get checked again
end

local function checkdiv(el)
  local lang = el.attributes.lang
  if not lang then return nil end
  pandoc.walk_block(el, {Str = function(e) add_to_dict(lang, e.text) end})
  return {} -- remove div, so it doesn't get checked again
end

return {{Meta = get_deflang},
        {Div = checkdiv, Span = checkspan},
        {Str = function(e) add_to_dict(deflang, e.text) end, Pandoc = results}}
