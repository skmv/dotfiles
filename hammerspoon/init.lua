local alert = require 'hs.alert'

import = require('utils/import')
import.clear_cache()

config = import('config')

function config:get(key_path, default)
    local root = self
    for part in string.gmatch(key_path, "[^\\.]+") do
        root = root[part]
        if root == nil then
            return default
        end
    end
    return root
end

local modules = {}

for _, v in ipairs(config.modules) do
    local module_name = 'modules/' .. v
    local module = import(module_name)

    if type(module.init) == "function" then
        module.init()
    end

    table.insert(modules, module)
end

local buf = {}

if hs.wasLoaded == nil then
    hs.wasLoaded = true
    table.insert(buf, "Hammerspoon loaded: ")
else
    table.insert(buf, "Hammerspoon re-loaded: ")
end

hs.window.switcher.ui.showSelectedThumbnail = false
hs.window.switcher.ui.showTitles = false
switcher = hs.window.switcher.new{'Emacs', 'Google Chrome', 'Rambox'} -- default windowfilter: only visible windows, all Spaces

hs.hotkey.bind('alt','tab',nil,function()switcher:next()end)
-- hs.hotkey.bind('alt','tab','Next window',function()
--                   local choices = {
--                      {
--                         ["text"] = "First Choice",
--                         ["subText"] = "This is the subtext of the first choice",
--                         ["uuid"] = "0001"
--                      },
--                      { ["text"] = "Second Option",
--                         ["subText"] = "I wonder what I should type here?",
--                         ["uuid"] = "Bbbb"
--                      },
--                      { ["text"] = "Third Possibility",
--                         ["subText"] = "What a lot of choosing there is going on here!",
--                         ["uuid"] = "III3"
--                      },
--                   }
--                   x = hs.chooser.new(print)
--                   x:choices(choices)
--                   x:show()
-- end)
-- hs.hotkey.bind('alt-shift','tab','Prev window',function()switcher:previous()end)

table.insert(buf, #modules .. " modules.")

alert.show(table.concat(buf))
