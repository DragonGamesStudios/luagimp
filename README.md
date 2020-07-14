# Suggestions
Please post your suggestions about features and about what features you'd like to be available first in the issues site.

# luaGIMP library
luaGimp library is created to use gimp features in lua. It is divided into modules with names very similiar to gimp names. For example, to acces gimp filesystem module, let's say: creating new file, you need to call:
```
luagimp.file.new {
    image_size = {
        width = 1920,
        height = 1080
    }
}
```

And for accessing tools, like "pencil", you need to call:
```
luagimp.select_tool(luagimp.tools.paint_tools.pencil)
```

# Requirements
This library requires Love2d to run. There are no other libraries, that this project needs.

# Development
Not all features will be available, but the project will be developed. If you are soon after project release date, probably even examples above don't work yet. Please, give your feedback.

# Help
In case you don't know how to use some features and what are the sub-modules of some module, simply use those two lines:
```
luagimp.set_log_output('log.log') -- as an argument, you can give another path

luagimp.help() --[[ if no arguments given, the function will show you available modules ]]

-- By giving luagimp module as argument, you will get its description

luagimp.help(luagimp.file)

-- [[And by giving luagimp module and function name as arguments, you will get function descirption]]

luagimp.help(luagimp.file, "new")

```

The help output will be written in your project's appdata folder in file with path given in luagimp.set_log_output. If you don't have a folder in appdata, you can use the string the function returns.

You can also check project's wiki for documentation.