local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'
local mouse = require 'hs.mouse'
local screen = require 'hs.screen'

local position = import('utils/position')
local monitors = import('utils/monitors')

local function init_module()
    for id, monitor in pairs(monitors.configured_monitors) do

        -- hotkey.bind({ "cmd", "ctrl" }, "" .. id, function()
        --     local midpoint = geometry.rectMidPoint(monitor.dimensions)
        --     mouse.set(midpoint)
        -- end)

        -- hotkey.bind({ "ctrl", "alt" }, "PAD" .. id, function()
        --     local win = window.focusedWindow()
        --     if win ~= nil then
        --         win:setFrame(position.left(monitor.dimensions))
        --     end
        -- end)

        -- hotkey.bind({ "cmd", "alt" }, "" .. id, function()
        --     local win = window.focusedWindow()
        --     if win ~= nil then
        --         win:setFrame(position.right(monitor.dimensions))
        --     end
        -- end)

        hotkey.bind({"ctrl", "alt", "cmd" }, "" .. id, function()
            local win = window.focusedWindow()
            if win ~= nil then
               win:setFrame(position.full(monitor.dimensions))
            end

        end)
    end
end

return {
    init = init_module
}
