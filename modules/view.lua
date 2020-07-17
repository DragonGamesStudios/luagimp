luagimp.view = {}

function luagimp.view.new(model)
    luagimp.needs_active_file()
    luagimp.variables.active_file.view =
        love.graphics.newCanvas(luagimp.variables.active_file.width, luagimp.variables.active_file.height)
    luagimp.variables.active_file.redraw_view = true
    luagimp.view.update()
end

function luagimp.view.update()
    luagimp.needs_view()
    if luagimp.variables.active_file.redraw_view then
        love.graphics.clear({1, 1, 1, 0})
        love.graphics.setCanvas(luagimp.variables.active_file.view)
        for li = #luagimp.variables.active_file.layers, 1, -1 do
            love.graphics.draw(luagimp.variables.active_file.layers[li].rendered)
        end
        love.graphics.setCanvas()
        luagimp.variables.active_file.redraw_view = false
    end
end

function luagimp.view.draw(x, y)
    luagimp.needs_view()
    love.graphics.draw(
        luagimp.variables.active_file.view,
        x,
        y,
        0,
        luagimp.view.zoom.variables.zoom,
        luagimp.view.zoom.variables.zoom,
        luagimp.variables.active_file.width / 2,
        luagimp.variables.active_file.height / 2
    )
end

if luagimp.variables.path.by == "dofile" then
    dofile(luagimp.variables.path.path .. "/sub-modules/view/zoom.lua")
else
    require(luagimp.variables.path.path .. ".sub-modules.view.zoom")
end
