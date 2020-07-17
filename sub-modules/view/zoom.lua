luagimp.view.zoom = {variables = {zoom = 1}}

function luagimp.view.zoom._in(value)
    luagimp.view.zoom.variables.zoom = luagimp.view.zoom.variables.zoom * value
end

function luagimp.view.zoom.out(value)
    luagimp.view.zoom.variables.zoom = luagimp.view.zoom.variables.zoom / value
end

function luagimp.view.zoom.set(value)
    luagimp.view.zoom.variables.zoom = value
end
