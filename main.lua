luagimp = {
    helpstring = "luagimp: main luagimp table. You can access every module and function using this.",
    variables = {
        log_output_path = "log.log",
        path = {
            by = "",
            path = ""
        },
        unit_formulas = {
            px = 1,
            ["in"] = 96,
            mm = 3.7795275591,
            pt = 1.3281472327365,
            pc = 16,
            cm = 37.795275591,
            m = 3779.5275591,
            ft = 1152,
            yd = 3456
        },
        available_fill_with = {
            "background-color",
            "foreground-color",
            "white",
            "transparency",
            "pattern"
        },
        background_color = {0, 0, 0},
        foreground_color = {1, 1, 1}
    },
    _DEBUG = false
}

function luagimp.set_log_output(path)
    luagimp.variables.log_output_path = path
end

function luagimp.log(...)
    if luagimp._DEBUG then
        if not love.filesystem.getInfo(luagimp.variables.log_output_path) then
            love.filesystem.newFile(luagimp.variables.log_output_path)
        end
        for i, v in ipairs({...}) do
            love.filesystem.append(luagimp.variables.log_output_path, v .. "\n")
        end
    end
end

function luagimp.help(obj, key)
    local res = "Unfotunately, this object does not have help string."
    obj = obj or luagimp
    if not key then
        if obj then
            if type(obj) == "table" then
                res = obj.helpstring .. "\nFields:\n"
                for k in pairs(obj) do
                    res = res .. "    - " .. k .. "\n"
                end
            end
        elseif type(obj) == "function" and getmetatable(obj) then
            res = tostring(obj)
        else
            res = "Unfotunately, this object does not exist."
        end
    else
        res = obj.helpstrings[key]
    end
    if not love.filesystem.getInfo(luagimp.variables.log_output_path) then
        love.filesystem.newFile(luagimp.variables.log_output_path)
    end
    love.filesystem.append(luagimp.variables.log_output_path, res .. "\n")
    return res
end

function luagimp.is_valid(value, options)
    for i, option in ipairs(options) do
        if value == option then
            return true, i
        end
    end
end

function luagimp.switch(default, value)
    if value == nil then
        return default
    else
        return value
    end
end

function luagimp.index(tab, elem, key)
    key = key or function(a)
            return a
        end
    for i, v in ipairs(tab) do
        if key(v) == elem then
            return i
        end
    end
end

function luagimp.get_color(format, r, g, b)
    local color = {r, g, b}
    if not g then
        color = r
    end
    if type(format) == "string" then
        if format == "RGB-255" then
            color[1] = color[1] / 255
            color[2] = color[2] / 255
            color[3] = color[3] / 255
        elseif format == "RGB-1" then
        elseif format == "HEX" then
            local hex = string.match(r, "[^#]......$")
            if not hex then
                error('luagimp error: Incorrect color value "' .. r .. '"', 2)
            end
            color = {
                tonumber(string.sub(hex, 1, 2), 16) / 255,
                tonumber(string.sub(hex, 3, 4), 16) / 255,
                tonumber(string.sub(hex, 5, 6), 16) / 255
            }
        end
    else
        color = {format, r, g}
        if not g then
            color = format
        end
    end
    return color
end

function luagimp.set_foreground_color(format, r, g, b)
    luagimp.variables.foreground_color = luagimp.get_color(format, r, g, b)
end

function luagimp.set_background_color(format, r, g, b)
    luagimp.variables.background_color = luagimp.get_color(format, r, g, b)
end

function luagimp.needs_active_file()
    if not luagimp.variables.active_file then
        error("luagimp error: Needs active file.", 3)
    end
end

function luagimp.needs_active_layer()
    if not luagimp.variables.active_file.active_layer then
        error("luagimp error: Needs active layer.", 3)
    end
end

function luagimp.needs_view()
    luagimp.needs_active_file()
    if not luagimp.variables.active_file.view then
        error("luagimp error: Needs view created.", 3)
    end
end

function luagimp.init(path, pathtype)
    if pathtype == "require" then
        luagimp.variables.path.path = path
        luagimp.variables.path.by = "require"

        -- import

        require(path .. ".modules.file")
        require(path .. ".modules.layer")
        require(path .. ".modules.view")
    elseif pathtype == "dofile" then
        luagimp.variables.path.path = path
        luagimp.variables.path.by = "dofile"

        -- import

        dofile(path .. "/modules/file.lua")
        dofile(path .. "/modules/layer.lua")
        dofile(path .. "/modules/view.lua")
    end
    love.filesystem.write(luagimp.variables.log_output_path, "")
end
