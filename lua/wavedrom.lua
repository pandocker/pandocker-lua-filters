--[[
# wavedrom.lua

]]

function Para(el)
    if #(el.content) == 1 then
        sub_el = el.content[1]
        if sub_el.tag == "Link" then
            --debug("Para content is a Link")
            local newp = wavedrom(sub_el)
            return newp
        end
    end
end

function wavedrom(el)

end
