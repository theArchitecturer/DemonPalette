local api = vim.api
--     _                      
-- ___| |__   __ _ _ __   ___ 
--/ __| '_ \ / _` | '_ \ / _ \
--\__ \ | | | (_| | |_) |  __/
--|___/_| |_|\__,_| .__/ \___|
--                |_|         
local TABLE = {
    rounded= {
        '╭', '─', '╮',
        '│', ' ', '│',
        '╰', '─', '╯',
    },
    sharp = {
        '┌', '─', '┐',
        '│', ' ', '│',
        '└', '─', '┘',
    },
    double_sharp = {
        '╔', '═', '╗',
        '║', ' ', '║',
        '╚', '╩', '╝',
    }
}

--  _   _   _   _   _   _  
-- / \ / \ / \ / \ / \ / \ 
--( w | i | n | d | o | w )
-- \_/ \_/ \_/ \_/ \_/ \_/ 

local option = {
    relative= "win",
    style= "minimal"
}

-- decoration
local _border

-- buf, window
local border_buf
local buf, win

local line
local range

local Layout = {
    center = function (_return)
        _return.height = math.ceil(api.nvim_win_get_height(0)/2)
        _return.width = math.ceil(api.nvim_win_get_width(0)/2)
        _return.row = math.ceil(_return.height/2)
        _return.col = math.ceil(_return.width/2)
        return _return
    end,

    top = function (_return)
        _return.height = math.ceil(api.nvim_win_get_height(0)/2)
        _return.width = math.ceil(api.nvim_win_get_width(0)/2)
        _return.row = 1
        _return.col = math.ceil(_return.width/4)
        return _return
    end,

    bot = function (_return)
        _return.height = math.ceil(api.nvim_win_get_height(0)/2)
        _return.width = math.ceil(api.nvim_win_get_width(0)/2)
        _return.row = math.ceil(api.nvim_win_get_width(0)/4)
        _return.col = api.nvim_win_get_height(0) - 1
        return _return
    end,

    location = function (layout, _return)
        _return.width = layout.width
        _return.height = layout.height
        _return.row = layout.row
        _return.col = layout.col
        return _return
    end,
}


local function init(border, layout)
    --border handle
    if (type(border) == table) then
        _border = border
    else
        local border = border or "rounded"
        _border = TABLE[border]
    end

    --layout handle
    if (type(layout) == table) then
        Layout['location'](layout, option)
    else 
        local layout = layout or "center"
        Layout[layout](option)
    end
end

local function border_hightlight() 
    for i=0, option.height + 1 do
        api.nvim_buf_add_highlight(border_buf, -1, 'Hel', i, 0, -1)
    end
end

local function open_border ()
    local components = _border
    border_buf = api.nvim_create_buf(false, true)

    local surround = { components[1] .. string.rep(components[2], option.width) .. components[3] }
    local middle = components[4] .. string.rep(components[5], option.width) .. components[6]
    for i=1, option.height do
        table.insert(surround, middle)
    end
    table.insert(surround, components[7] .. string.rep(components[8], option.width) .. components[9])
    api.nvim_buf_set_lines(border_buf, 0, -1, false, surround)

    local win_opts = {
        relative= "win",
        style= "minimal"
    }
    win_opts.width = option.width + 2
    win_opts.height = option.height + 2
    win_opts.row = option.row - 1
    win_opts.col = option.col - 1
    -- local border_win = api.nvim_open_win(border_buf, true, win_opts)
    api.nvim_open_win(border_buf, true, win_opts)

    border_hightlight()
end


local function title_handle(title)
    local title = string.upper(title)..'ᐳ '
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 0, 1, false, {title})
    api.nvim_buf_add_highlight(buf, -1, 'Title', 0, 0, #title)
end

local function open(title)
    open_border()

    buf = api.nvim_create_buf(false, true)

    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(buf, 'filetype', 'window')
    api.nvim_buf_set_option(0, 'buftype', 'nofile')
    api.nvim_buf_set_option(0, 'swapfile', false)
    api.nvim_command('setlocal nowrap')

    win = api.nvim_open_win(buf, true, option)
    api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. border_buf)
    title_handle(title)
end


local function search_key_binding()
    local mappings = {
        ['<down>']= 'search_down_action()',
        ['<up>']= 'search_up_action()',
        ['<Esc>'] = 'close()'
    }
    for k,v in pairs(mappings) do
        api.nvim_buf_set_keymap(buf, 'i', k, '<C-o>:lua require"window".'..v.."<cr>", {
            nowait = true, noremap = true, silent = true
        })
    end
end


local function set_line()
    line = 1
end

local function search_down_action()
    api.nvim_buf_add_highlight(buf, -1, 'NormalLine', line, 0, -1)
    line = line + 1
    if (line == range + 1) then
        set_line()
    end
    api.nvim_buf_add_highlight(buf, -1, 'CurrentLine', line, 0, -1)
end


local function search_up_action()
    api.nvim_buf_add_highlight(buf, -1, 'NormalLine', line, 0, -1)
    line = line - 1
    if (line == 0) then
        line = range 
    end
    api.nvim_buf_add_highlight(buf, -1, 'CurrentLine', line, 0, -1)
end


local function key_binding(mappings, module)
    for k,v in pairs(mappings) do
        api.nvim_buf_set_keymap(buf, 'i', k, ':lua require"'..module..'"'..v..'() <cr>', {
            nowait = true, noremap = true, silent = true
        })
    end
end


local function update(list)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 1, option.height, false, list)
    range = #list
end


local function close()
    api.nvim_buf_set_option(buf, 'modifiable', false)
    api.nvim_command('stopinsert')
    api.nvim_win_close(win, true)
end

local function search()
    set_line()
    api.nvim_buf_add_highlight(buf, -1, 'CurrentLine', line, 0, -1)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_command('startinsert')
end

--- Open a new window for search
---@see |search|
local function open_search(title, border, layout)

    init(border, layout)

    -- open_border()
    open(title)
    search_key_binding()
    search()
end

return {
    open = open_search,
    update = update,

    --key binding
    search_down_action = search_down_action,
    search_up_action = search_up_action,
    close = close,
}
