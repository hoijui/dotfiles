-- fc.lua
--    ���O�ɓ��͂����R�}���h���G�f�B�^�[�ŊJ���R�}���h�ufc�v

function nyaos.command.fc()
    local editor=os.getenv("EDITOR")
    if not editor or string.len(editor) <= 0 then
        if nyaos.create_object then
            editor = "notepad"
        else
            editor = "e.exe"
        end
    end
    local text = nyaos.history[ nyaos.history:len()-1 ]
    if text then
        local tempfname=os.tmpname()
        local fd = io.open(tempfname,"w")
        fd:write(text.."\n")
        fd:close()
        os.execute(editor..' \034'..tempfname..'\034' )
        os.remove( tempfname )
    else
        print("There is no history text.")
    end
end
