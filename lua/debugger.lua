function debug(string)
    io.stderr:write(string .. "\n")
end

return {
    debug = debug,
}
