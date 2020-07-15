luagimp.layer = {
    variables = {
        available_modes = {
            "normal",
            "dissolve",
            "color-erase",
            "erase",
            "merge",
            "split",
            "lighten-only",
            "luminance-lighten-only",
            "screen",
            "dodge",
            "addition",
            "darken-only",
            "luminance-darken-only",
            "multiply",
            "burn",
            "linear-burn",
            "overlay",
            "soft-light",
            "hard-light",
            "vivid-light",
            "pin-light",
            "linear-light",
            "hard-mix",
            "difference",
            "exclusion",
            "subtract",
            "grain-extract",
            "grain-merge",
            "divide",
            "hsv-hue",
            "hsv-saturation",
            "hsv-color",
            "hsv-value",
            "lch-hue",
            "lch-color",
            "lch-chroma",
            "lch-lightness",
            "luminance"
        },
        available_composite_spaces = {
            "RGB-linear",
            "RGB-perceptrual",
            "auto"
        },
        available_composite_modes = {
            "auto",
            "union",
            "clip-to-background",
            "clip-to-layer",
            "intersection"
        }
    }
}

function luagimp.layer.new(model)
    luagimp.needs_active_file()
    local new_layer = {}
    new_layer.name = model.name or "Unnamed"

    -- name duplicate check
    local appears = false
    local last_value = 0
    for _, layer in ipairs(luagimp.variables.active_file.layers) do
        if not appears then
            if layer.name == new_layer.name then
                appears = true
                last_value = 1
            end
        else
            local numpos = string.find(layer.name, "%s#%d+%s*$")
            if string.sub(layer.name, 1, numpos-1) == new_layer.name then
                local num = tonumber(string.sub(string.match(layer.name, "%s#%d+%s*$"), 3))
                if num >= last_value then
                    last_value = num + 1
                end
            end
        end
    end

    -- name correction
    if last_value > 0 then
        new_layer.name = new_layer.name .. " #" .. last_value
    end

    -- mode, composite space, composite mode
    new_layer.mode = model.mode or "normal"
    new_layer.composite_space = model.composite_space or "auto"
    new_layer.composite_mode = model.composite_mode or "auto"

    -- number values
    new_layer.width = model.width or luagimp.variables.active_file.width
    new_layer.height = model.height or luagimp.variables.active_file.height
    local dim_unit = model.dimensions_unit or 'px'

    new_layer.x_offset = model.x_offset or 0
    new_layer.y_offset = model.y_offset or 0
    local off_unit = model.offset_unit or 'px'

    new_layer.opacity = model.opacity or 100

    -- fill with
    new_layer.fill_with = model.fill_with or "transparency"

    -- switches
    model.switches = model.switches or {}
    new_layer.switches = {
        visible = luagimp.switch(true, model.switches.visible),
        linked = luagimp.switch(false, model.switches.linked),
        lock_pixels = luagimp.switch(false, model.switches.lock_pixels),
        lock_position_and_size = luagimp.switch(false, model.switches.lock_position_and_size),
        lock_alpha = luagimp.switch(false, model.switches.lock_alpha),
    }

    -- unit application
    if not luagimp.variables.unit_formulas[dim_unit] then
        error("luagimp error: Incorrect unit \"" .. dim_unit .. "\"", 2)
    end

    if not luagimp.variables.unit_formulas[off_unit] then
        error("luagimp error: Incorrect unit \"" .. dim_unit .. "\"", 2)
    end

    local formula1 = luagimp.variables.unit_formulas[dim_unit]
    local formula2 = luagimp.variables.unit_formulas[off_unit]
    if dim_unit == "in" then formula1 = luagimp.variables.active_file.x_resolution end
    if off_unit == "in" then formula2 = luagimp.variables.active_file.x_resolution end

    new_layer.width = new_layer.width * formula1
    new_layer.x_offset = new_layer.x_offset * formula2

    if dim_unit == "in" then formula1 = luagimp.variables.active_file.y_resolution end
    if off_unit == "in" then formula2 = luagimp.variables.active_file.y_resolution end

    new_layer.height = new_layer.height * formula1
    new_layer.y_offset = new_layer.y_offset * formula2

    -- error check
    if not luagimp.is_valid(new_layer.mode, luagimp.layer.variables.available_modes) then
        error("luagimp error: Incorrect value \"" .. new_layer.mode .. "\" for mode", 2)
    end

    if not luagimp.is_valid(new_layer.composite_space, luagimp.layer.variables.available_composite_spaces) then
        error("luagimp error: Incorrect value \"" .. new_layer.composite_space .. "\" for composite_space", 2)
    end

    if not luagimp.is_valid(new_layer.composite_mode, luagimp.layer.variables.available_composite_modes) then
        error("luagimp error: Incorrect value \"" .. new_layer.composite_mode .. "\" for composite_mode", 2)
    end

    if not luagimp.is_valid(new_layer.fill_with, luagimp.variables.available_fill_with) then
        error("luagimp error: Incorrect value \"" .. new_layer.fill_with .. "\" for fill_with", 2)
    end

    -- finalizing
    local put_in = luagimp.index(luagimp.variables.active_file.layers, luagimp.variables.active_file.active_layer)
    if not put_in then put_in = 1 end
    table.insert(luagimp.variables.active_file.layers, put_in, new_layer)
end

function luagimp.layer.set_switch(layer, switch_id, value)
    layer.switches[switch_id] = value
end

if luagimp.variables.path.by == "dofile" then
    dofile (luagimp.variables.path.path .. "/sub-modules/layer/stack.lua")
else
    require (luagimp.variables.path.path .. ".sub-modules.layer.stack")
end