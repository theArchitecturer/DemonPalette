function! palette#config#file()
    return g:palette#config#file

function! palette#config#border()
    return luaeval(
                \ 'require(_A).border',
                \ call palette#config#border()
    )
