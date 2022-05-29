-- JA <> EN switch
henkan = hs.hotkey.bind({},"`", function()
    if hs.keycodes.currentMethod() == "Hiragana" then
        hs.eventtap.keyStroke({}, 0x66) -- 英数キー
    else
        hs.eventtap.keyStroke({}, 0x68) -- かなキー
    end
end)

-- A shortcut key (CMD + CTRL + A) to open the Control Center
controlCenter = hs.hotkey.bind({"ctrl", "cmd"}, "a", function()
    local point = {x=1256, y=13}
hs.eventtap.leftClick(point, 0)
end)

-- HANDLE SCROLLING
local deferred = false

overrideOtherMouseDown = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(e)
    --print("down"))
    deferred = true
    return true
end)

overrideOtherMouseUp = hs.eventtap.new({ hs.eventtap.event.types.otherMouseUp }, function(e)
    -- print("up"))
    if (deferred) then
        overrideOtherMouseDown:stop()
        overrideOtherMouseUp:stop()
        hs.eventtap.otherClick(e:location())
        overrideOtherMouseDown:start()
        overrideOtherMouseUp:start()
        return true
    end

    return false
end)

local oldmousepos = {}
local scrollmult = -4   -- negative multiplier makes mouse work like traditional scrollwheel
dragOtherToScroll = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDragged }, function(e)
    -- print("scroll");

    deferred = false

    oldmousepos = hs.mouse.getAbsolutePosition()    

    local dx = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
    local dy = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
    local scroll = hs.eventtap.event.newScrollEvent({dx * scrollmult, dy * scrollmult},{},'pixel')

    -- put the mouse back
    hs.mouse.setAbsolutePosition(oldmousepos)

    return true, {scroll}
end)

overrideOtherMouseDown:start()
overrideOtherMouseUp:start()
dragOtherToScroll:start()