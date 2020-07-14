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
        }
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

function luagimp.init(path, pathtype)
    if pathtype == "require" then
        luagimp.variables.path = path
        luagimp.variables.by = "require"

        -- import

        require (path .. ".modules.file")
    elseif pathtype == "dofile" then
        luagimp.variables.path = path
        luagimp.variables.by = "dofile"

        -- import

        dofile (path .. "/modules/file.lua")
    end
    love.filesystem.write(luagimp.variables.log_output_path, "")
end

function luagimp.create_function_helpstring(fun, helpstring)
    setmetatable(fun, {
        __tostring = function() return helpstring end
    })
end