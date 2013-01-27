' usage: CScript.exe replaceStr.vbs [File] [findString] [replaceString]
	' ��������
	if WScript.Arguments.Count <> 3 then
		Dim m
		m=""
		m=m & "help" & vblf
		m=m & "" & vblf
		WScript.Echo m
		WScript.Quit
	end if

	'For Each argv In WScript.Arguments
	'next
	Set argv = WScript.Arguments
	set objCtl = New ClsFileReplace
	'objCtl.loglevel = 1				' Debug
	objCtl.loglevel = 5
	'objCtl.FindSubFolderFlag = False

	objCtl.findStr = argv(1)
	objCtl.ReplaceStr = argv(2)
	Call objCtl.Main( argv(0) )
	Set objCtl = Nothing


' Class ��`
Class ClsFileReplace
	Dim findStr, replaceStr
	Dim logLevel
	Dim objFso
	Dim FindSubFolderFlag
	Private bFind

	Private Sub Class_Initialize   ' Initialize �C�x���g��ݒ肵�܂��B
		findStr = ""
		replaceStr = ""
		Set objFso = CreateObject("Scripting.FileSystemObject")
		logLevel = 5
		FindSubFolderFlag = True
		bFind = false
	End Sub
	Private Sub Class_Terminate   ' Terminate �C�x���g��ݒ肵�܂��B
		Set objFs = Nothing
	End Sub

	Sub Main( argv )
		Call TraceOut(1, "Start: argv = " & argv)
		Call scanFolder( argv )

	End Sub

	Sub scanFolder( targetPath )
		Call TraceOut(2, "scanFolder,target = " & targetpath)
		if objFs.FolderExists(targetPath) then ' ���݂���t�H���_��?
			Dim objSubFolder, objSrcFolder
			Dim FileName
			Set objSrcFolder = objFs.GetFolder(targetPath)			   ' �Ώۃt�H���_�̎w��
			Set objSubFolder = objSrcFolder.SubFolders

			' �w��̃t�H���_�Ɋi�[���ꂽ�e�t�@�C������������
			For Each FileName In objSrcFolder.Files
					Call executeForFile( FileName )
			Next

			for each tmp in objsubfolder
				if FindSubFolderFlag or (FindSubFolderFlag = false And bFind = False) then
					Call scanFolder(targetPath & "\" & tmp.name)	' �T�u�t�H���_�̃t�@�C������
				End if
			next
		else
			Call executeForFile( targetPath )
		End If
	End Sub

	Sub executeForFile( FileName )
		bFind = True
		Call TraceOut(2, "executeForFile, target = " & FileName)

		ReplaceString(FileName)
	end Sub

	Sub ReplaceString(FilePath)
		' �t�@�C���Ǎ�
		Dim inFilePath													' �t�@�C���ǂݍ���
		Dim WshShell
		Dim stream
		Const ForReading = 1,ForWriting = 2, ForAppending = 8
		Const BACKUP_EXT = ".bak"

		if Len(findStr) < 0 then
			Call TraceOut(2, "ReplaceString, exit(findkey length = 0)")
			exit sub
		end if

		If Not (objFso.FileExists(FilePath)) Then
			Call TraceOut(2, "ReplaceString, exit(not found filepath)")
			Exit Sub
		End If

		Set stream = objFso.OpenTextFile(FilePath, ForReading)

		Dim readBuf
		readBuf = stream.ReadAll
		stream.Close
		set stream = Nothing

		if 0 < inStr( readbuf, findStr) then
			Dim backupFilePath
			backupFilePath = FilePath & BACKUP_EXT
			if Not(objFso.FileExists( backupFilePath )) then
				Call TraceOut(2, "ReplaceString, backup " & FilePath & "->" & backupFilePath)
				Call objFso.CopyFile(FilePath , backupFilePath)
			End if
		End if

		Dim regEx
		Set regEx = New RegExp							' �����񌟍��p�I�u�W�F�N�g�̍쐬
		regEx.Pattern = findStr					 ' ����������������p�^�[���Ƃ��Ďw��
		regEx.Global = True							 ' ������S�̂���������悤�Ɏw��
		regEx.IgnoreCase = True						 ' �啶���E�������͌����ɉe�����Ȃ�
		readBuf = regEx.Replace(readBuf, replaceStr)
		//readBuf = Replace( readBuf, findStr, replaceStr)

		Dim outStream
		Set outStream = objFso.OpenTextFile(FilePath, ForWriting)
		Call outStream.Write( readBuf )
		outStream.Close

		set objFso = Nothing
		Set outStream = Nothing
	End Sub


	' ���O�o�͊֐�
	Sub TraceOut(level , msg)
	    Dim FilePath
	    Dim stream
	    Const ForReading = 1, ForWriting = 2, ForAppending = 8

	    if logLevel > level then exit sub
	    FilePath = WScript.ScriptFullName & ".log"

	    If Not (objFs.FileExists(FilePath)) Then
	        Set stream = objFs.createtextfile(FilePath, False)
	    Else
	        Set stream = objFs.OpenTextFile(FilePath, ForAppending)
	    End If
	    'stream.WriteLine (FormatDateTime(Now()) & "|" & msg)
	    stream.WriteLine msg
	End Sub

End Class

