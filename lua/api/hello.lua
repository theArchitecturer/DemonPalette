local function hello()
    -- local info = debug.getinfo(1,'S');
    -- print(info.source);
    print(arg[0])
end

return {
    hello = hello
}
