-- quote_luaexp.lua
--     Lua�����R�}���h���C���ň��p�ł���悤�ɂ���B
--     �u%(1+2)%�v�́u3�v�ɂȂ�B

function nyaos.filter.quote_lua_expression(cmdline)
    return cmdline:gsub('%%(%b())%%',function(m)
        local status,result=pcall( loadstring('return '..m) )
        if status then
            return result
        else
            print('Ignore invalid Lua expression: '..m)
            return false;
        end
    end)
end
