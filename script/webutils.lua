function HTML_ToText (text)
  -- Declare variables, load the file. Make tags lowercase.
  nl = "\n"
  text = string.gsub (text,"(<([^>]-)>)",function (str) return str:lower() end)
  --[[ 
  First we kill the developer formatting (tabs, CR, LF)
  and produce a long string with no newlines and tabs.
  We also kill repeated spaces as browsers ignore them anyway.
  ]]
  local devkill=
    {
      ["("..string.char(10)..")"] = " ",
      ["("..string.char(13)..")"] = " ",
      ["("..string.char(15)..")"] = "",
      ["(%s%s+)"]=" ",
    }
  for pat, res in pairs (devkill) do
    text = string.gsub (text, pat, res)
  end
  -- Then we remove the header. We do this by stripping it first.
  text = string.gsub (text, "(<%s*head[^>]*>)", "<head>")
  text = string.gsub (text, "(<%s*%/%s*head%s*>)", "</head>")
  text = string.gsub (text, "(<head>,*<%/head>)", "")
  -- Kill all scripts. First we nuke their attribs.
  text = string.gsub (text, "(<%s*script[^>]*>)", "<script>")
  text = string.gsub (text, "(<%s*%/%s*script%s*>)", "</script>")
  text = string.gsub (text, "(<script>,*<%/script>)", "")
  -- Ok, same for styles.
  text = string.gsub (text, "(<%s*style[^>]*>)", "<style>")
  text = string.gsub (text, "(<%s*%/%s*style%s*>)", "</style>")
  text = string.gsub (text, "(<style>.*<%/style>)", "")
  
  -- Replace <td> and <th> with tabulators.
  text = string.gsub (text, "(<%s*td[^>]*>)","\t")
  text = string.gsub (text, "(<%s*th[^>]*>)","\t")
  
  -- Replace <br> with linebreaks.
  text = string.gsub (text, "(<%s*br%s*%/%s*>)",nl)
  
  -- Replace <li> with an asterisk surrounded by spaces.
  -- Replace </li> with a newline.
  text = string.gsub (text, "(<%s*li%s*%s*>)"," *  ")
  text = string.gsub (text, "(<%s*/%s*li%s*%s*>)",nl)
  
  -- <p>, <div>, <tr>, <ul> will be replaced to a double newline.
  text = string.gsub (text, "(<%s*div[^>]*>)", nl..nl)
  text = string.gsub (text, "(<%s*p[^>]*>)", nl..nl)
  text = string.gsub (text, "(<%s*tr[^>]*>)", nl..nl)
  text = string.gsub (text, "(<%s*%/*%s*ul[^>]*>)", nl..nl)
    
  -- Some petting with the <a> tags. :-P
  local addresses,c = {},0
  text=string.gsub(text,"<%s*a.-href=[\'\"](%S+)[\'\"][^>]*>(.-)<%s*%/*%s*a[^>]->", -- gets URL from a tag, and the enclosed name
  function (url,name)
    c = c + 1
    name = string.gsub (name, "<([^>]-)>","") -- strip name from tags (e. g. images as links)
    
    -- We only consider the URL valid if the name contains alphanumeric characters.
    if name:find("%w") then print(url, name, c) table.insert (addresses, {url, name}) return name.."["..#addresses.."]" else return "" end    
  end)

  -- Nuke all other tags now.
  text = string.gsub (text, "(%b<>)","")
  
  -- Replace entities to their correspondant stuff where applicable.
  -- C# is owned badly here by using a table. :-P
  -- A metatable secures entities, so you can add them natively as keys.
  -- Enclosing brackets also get added automatically (capture!)
  local entities = {}
  setmetatable (entities,
  {
    __newindex = function (tbl, key, value)
      key = string.gsub (key, "(%#)" , "%%#")
      key = string.gsub (key, "(%&)" , "%%&")
      key = string.gsub (key, "(%;)" , "%%;")
      key = string.gsub (key, "(.+)" , "("..key..")")
      rawset (tbl, key, value)
    end
  })
  entities = 
  {
    ["&nbsp;"] = " ",
    ["&bull;"] = " *  ",
    ["&lsaquo;"] = "<",
    ["&rsaquo;"] = ">",
    ["&trade;"] = "(tm)",
    ["&frasl;"] = "/",
    ["&lt;"] = "<",
    ["&gt;"] = ">",
    ["&copy;"] = "(c)",
    ["&reg;"] = "(r)",
    -- Then kill all others.
    -- You can customize this table if you would like to, 
    -- I just got bored of copypasting. :-)
    -- http://hotwired.lycos.com/webmonkey/reference/special_characters/
    ["%&.+%;"] = "",
  }
  for entity, repl in pairs (entities) do
    text = string.gsub (text, entity, repl)
  end
--   text = text..nl..nl..("-"):rep(27)..nl..nl
--   
--   for k,v in ipairs (addresses) do
--     text = text.."["..k.."] "..v[1]..nl
--   end
  if #addresses > 0 then
    text=text..nl:rep(2)..("-"):rep(2)..nl
    for key, tbl in ipairs(addresses) do
      text = text..nl.."["..key.."]"..tbl[1]
    end
  end
  
  return text
  
end

--[[
Copyright (c) 2007, bastya_elvtars

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used
      to endorse or promote products derived from this code without specific
      prior written permission.

THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
CODE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]