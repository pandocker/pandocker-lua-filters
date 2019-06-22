local stringify = require("pandoc.utils").stringify

function Para(el)
    local rep = {}
    for i, v in ipairs(el.content) do
        --print(i .. " " .. v.tag .. "(" .. stringify(v) .. ")")
        table.insert(rep, v)
        if v.tag == "SoftBreak" or i == #el.content then
            if #rep >= 3 then
                --for ii, vv in ipairs(rep) do
                --    print(vv.tag .. "(" .. stringify(vv) .. ")")
                --end
                if rep[1].tag == "Str" and rep[2].tag == "Space" and rep[3].tag == "Quoted" then
                    print(stringify(rep[3].content))
                end
            end
            rep = {}
        end
    end
end
