# compatible.ny
#    CMD.EXE �����R�}���h�����̂܂܎g����悤�ɂ���G�C���A�X�E�֐���` ###

foreach i (mkdir rmdir type md rd start assoc)
    alias $i $COMSPEC /c $i
end

foreach cmd (dir copy move del rename ren del attrib for)
    $cmd{
        if %glob.defined% -ne 0 then
            option -glob
            $COMSPEC /c $0 $*
            option +glob
        else
            $COMSPEC /c $0 $*
        endif
    }
end
