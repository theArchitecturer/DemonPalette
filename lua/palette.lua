local api = vim.api
local Window = require'window'

local key_map = {
    ['<cr>'] = 'handle()',
}


local List = {
    { "Preferences: Color Theme", "color", "open" },
    { 'Python', 'hello' },
    { 'Python', 'hello' },
    { 'Python', 'hello' },
    { 'Python', 'hello' }
}


local function handle()
    local capture = api.nvim_get_current_line()
    for val=1, #List do
        if (List[val][1] == capture) then
            local module = List[val][2]
            local func = List[val][3]
            Window.close()
            require(module)[func]()
        end
    end
end

local function load_content()
    local _return = {}

    for val=1, #List do
        table.insert(_return, List[val][1])
    end

    return _return
end


local function open_command_palatte(border, layout)
    Window.module = 'palette'
    Window.open('hello')
    Window.update(load_content())
end

return {
    open = open_command_palatte,
    handle = handle,
    close = close
}
