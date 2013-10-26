-- which.lua
--    �R�}���h�̂����ꂽ�f�B���N�g���𒲂ׂ�

-- �ėp which
function nyaos.which(cmd)
    local path='.;' .. os.getenv('PATH')
    local variation={
        [ cmd ] = true ,
        [ cmd .. '.exe' ] = true ,
        [ cmd .. '.cmd' ] = true ,
        [ cmd .. '.bat' ] = true ,
        [ cmd .. '.com' ] = true
    }

    local result={}
    for dir1 in string.gmatch(path,'[^;]+') do
        for name1 in pairs(variation) do
            local fullpath=dir1.."\\"..name1
            if nyaos.access(fullpath) then
                table.insert(result,fullpath)
            end
        end
    end
    return result
end

function nyaos.command.which(cmd)
    local path='.;' .. os.getenv('PATH')

    --- �����������ꍇ�́APATH �̈ꗗ��\�����邾�� ---
    if not cmd then
        for path1 in path:gmatch('[^;]+') do
            print(path1)
        end
        return
    end

    local cmdl=cmd:lower()

    --- �G�C���A�X������ ---
    local a=nyaos.alias[ cmdl ]
    if a then
        print('aliased as '..a)
    end

    --- �֐������� ---
    local f=nyaos.functions[ cmd ]
    if f then
        print('defined as function')
    end

    --- Lua �֐������� ---
    local L=nyaos.command[ cmd ]
    if L then
        print('define as Lua-function')
    end

    --- PATH ������ ---
    local result=nyaos.which(cmd)
    for i,e in ipairs(result) do
        print(e)
    end
end
