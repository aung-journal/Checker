function table.concat(t1, t2)
    local result = {}
    table.move(t1, 1, #t1, 1, result)
    table.move(t2, 1, #t2, #t1 + 1, result)
    return result
end