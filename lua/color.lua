local api = vim.api
local Window = require'window'.Window
local window = Window.new()

local key_map = {
    ['<down>'] = 'down_action()',
    ['<up>'] = 'up_action()',
    ['<Esc>'] = 'close()'
}

local function set_color_theme()
    local theme = api.nvim_get_current_line()
    api.nvim_command('colorscheme ' .. theme)
end

local function down_action()
    api.nvim_command('normal j')
    set_color_theme()
end

local function up_action()
    api.nvim_command('normal k')
    set_color_theme()
end

local function close()
    window:close()
end

local function load_theme()
    local list = api.nvim_eval("globpath(&rtp, 'colors/*.vim')")

    local _return = {}
    for val in list:gmatch("[^/]%w+%.vim") do
        table.insert(_return, val:sub(1,#val-4))
    end
    return _return 
end

local function open()
    window:open()
    window:update(load_theme())
    api.nvim_win_set_cursor(window.win, {1, 2})
    set_color_theme()

    window:key_binding(key_map, "color")
end

return {
    open = open,
    down_action = down_action,
    up_action = up_action,
    close = close,
}
