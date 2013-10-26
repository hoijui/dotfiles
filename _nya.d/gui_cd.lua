-- gui_cd.lua
--    �ucd @�v�ŁA�V�����f�B���N�g���� GUI �̃_�C�A���O�Ŏw��ł���
--    �悤�ɂ���

if nyaos.create_object then
    function nyaos.command.cd(arg)
        if arg == '@' then
            local objShell=nyaos.create_object('shell.application')
            local folder = objShell:BrowseForFolder(0, '�t�H���_�I��', 0)
            if not folder or not folder.self or folder.self.path then
                return 
            end
            arg = folder.self.path
        end
        if arg and string.match(arg,' ') then
            arg = '\034'..arg..'\034'
        end
        nyaos.exec('__cd__ '..(arg or ''))
    end
end
