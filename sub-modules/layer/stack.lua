luagimp.layer.stack = {}

function luagimp.layer.stack.select(layer)
    luagimp.needs_active_file()
    local puterror
    if type(layer) == "number" then
        if luagimp.variables.active_file.layers[layer] then
            luagimp.variables.active_file.active_layer = luagimp.variables.active_file.layers[layer]
        else
            puterror = "luagimp error: Attempt to activate not existing layer."
        end
    elseif type(layer) == "string" then
        if layer == "below" then
            if not luagimp.variables.active_file.active_layer then
                puterror = "luagimp error: no active layer. Cannot proceed."
            end
        elseif layer == "above" then
            if not luagimp.variables.active_file.active_layer then
                puterror = "luagimp error: no active layer. Cannot proceed."
            end
        elseif layer == "top" then
            luagimp.variables.active_file.active_layer = luagimp.variables.active_file.layers[1]
        elseif layer == "bottom" then
            luagimp.variables.active_file.active_layer = luagimp.variables.active_file.layers[#luagimp.variables.active_file.layers]
        else
            puterror = "luagimp error: Unexpected layer identifier \"" .. layer .. "\""
        end
    elseif type(layer) == "table" then
        if luagimp.index(luagimp.variables.active_file.layers, layer) then
            luagimp.variables.active_file.active_layer = layer
        else
            puterror = "luagimp error: Layer does not exist."
        end
    end
    if puterror then
        error(puterror, 2)
    end
    luagimp.log("Selected another layer.")
end

function luagimp.layer.stack.delete(layer)
    luagimp.needs_active_file()
    if not layer then
        luagimp.needs_active_layer()
        layer = luagimp.variables.active_file.active_layer
    end
    local puterror
    if type(layer) == "number" then
        if luagimp.variables.active_file.layers[layer] then
            table.remove( luagimp.variables.active_file.layers, layer )
            luagimp.layer.stack.select(layer)
        else
            puterror = "luagimp error: Attempt to delete not existing layer."
        end
    elseif type(layer) == "table" then
        local ind = luagimp.index(luagimp.variables.active_file.layers, layer)
        if ind then
            table.remove( luagimp.variables.active_file.layers, ind )
            if #luagimp.variables.active_file.layers > 0 then luagimp.layer.stack.select(ind) else luagimp.variables.active_file.active_layer = nil end
        else
            puterror = "luagimp error: Layer does not exist."
        end
    end
    if puterror then
        error(puterror, 2)
    end
    luagimp.log("Successfully deleted layer.")
end

function luagimp.layer.stack.move(layer, where)
    luagimp.needs_active_file()
    local puterror
    if not where then
        luagimp.needs_active_layer()
        where = layer
        layer = luagimp.variables.active_file.active_layer
    end
    if type(layer) == "number" then
        if luagimp.variables.active_file.layers[layer] then
            local moved = luagimp.variables.active_file.layers[layer]
            table.remove( luagimp.variables.active_file.layers, layer )
            if type(where) == "number" then
                table.insert( luagimp.variables.active_file.layers, where, moved )
            elseif type(where) == "string" then
                if where == "below" then
                    table.insert( luagimp.variables.active_file.layers, layer+1, moved )
                elseif layer == "above" then
                    table.insert( luagimp.variables.active_file.layers, math.max(1, layer-1), moved )
                elseif layer == "top" then
                    table.insert( luagimp.variables.active_file.layers, 1, moved )
                elseif layer == "bottom" then
                    table.insert( luagimp.variables.active_file.layers, moved )
                else
                    puterror = "luagimp error: Unexpected layer identifier \"" .. layer .. "\""
                end
            end
        else
            puterror = "luagimp error: Attempt to delete not existing layer."
        end
    elseif type(layer) == "table" then
        local ind = luagimp.index(luagimp.variables.active_file.layers, layer)
        if ind then
            table.remove( luagimp.variables.active_file.layers, ind )
            if type(where) == "number" then
                table.insert( luagimp.variables.active_file.layers, where, layer )
            elseif type(where) == "string" then
                if where == "below" then
                    table.insert( luagimp.variables.active_file.layers, ind+1, layer )
                elseif layer == "above" then
                    table.insert( luagimp.variables.active_file.layers, math.max(1, ind-1), layer )
                elseif layer == "top" then
                    table.insert( luagimp.variables.active_file.layers, 1, layer )
                elseif layer == "bottom" then
                    table.insert( luagimp.variables.active_file.layers, layer )
                else
                    puterror = "luagimp error: Unexpected layer identifier \"" .. layer .. "\""
                end
            end
        else
            puterror = "luagimp error: Layer does not exist."
        end
    end
    if puterror then
        error(puterror, 2)
    end
    luagimp.log("Successfully moved layer.")
end