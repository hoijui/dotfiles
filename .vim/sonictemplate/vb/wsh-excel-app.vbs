if WScript.Arguments.Count = 0 then
	Dim m
	m=""
	m=m & "help" & vblf
	m=m & "" & vblf
	WScript.Echo m
	WScript.Quit
end if

Dim handler
Set handler = New ExcelHandler
handler.MacroName = "fuga"

For Each argv In WScript.Arguments
	handler.Main( argv )
next
Set handler= Nothing

WScript.Echo "�I�����܂����B"

' Class ��`
Class ExcelHandler
	Dim logLevel
	Dim xls
	Dim fso
	Dim MacroName

	Private Sub Class_Initialize   ' Initialize �C�x���g��ݒ肵�܂��B
		set xls = CreateObject("Excel.Application")
		Set fso = CreateObject("Scripting.FileSystemObject")
		'xls.Visible = True
		xls.DisplayAlerts = False
		logLevel = 5
	End Sub
	Private Sub Class_Terminate   ' Terminate �C�x���g��ݒ肵�܂��B
		xls.quit
		set xls = Nothing
		Set fso = Nothing
	End Sub

	Sub Main( ArgPath )
		'Log(ArgPath)
		if fso.FolderExists(ArgPath) then ' ���݂���t�H���_��?
			Set objSrcFolder = fso.GetFolder(ArgPath)			   ' �Ώۃt�H���_�̎w��
			Set objsubfolder = objSrcFolder.SubFolders

			' �w��̃t�H���_�Ɋi�[���ꂽ�e�t�@�C������������
			For Each FileName In objSrcFolder.Files
				Call Main(FileName)
			Next

			for each tmp in objsubfolder
				Call ExecuteForFile(ArgPath & "\" & tmp.name)	' �T�u�t�H���_�̃t�@�C������
			next
		else
			Call ExecuteForFile( ArgPath )
		End If
	End Sub

	Sub ExecuteForFile( FileName )
		'on error resume next
		Dim wbk
		Dim ret
		Dim ext

		ext = fso.GetExtensionName(FileName)

		If Len(MacroName) <= 0 Then Exit Sub
		If Not(fso.FileExists(FileName)) Then Exit Sub
		If LCase(ext) <> "xls" Then Exit Sub

		Set wbk = xls.Workbooks.Open(Filename)
		Call xls.Run( "'" & FileName & "'!" & MacroName )
		wbk.Save
		wbk.Saved = true
		wbk.Close
	end Sub

	' ���O�o�͊֐�
	Sub Log(msg)
	    Dim logFileName
	    Dim stream
	    Const ForReading = 1, ForWriting = 2, ForAppending = 8

	    if logLevel > level then exit sub
	    logFileName = WScript.ScriptFullName & ".log"

	    If Not (fso.FileExists(logFileName)) Then
	        Set stream = fso.createtextfile(logFileName, False)
	    Else
	        Set stream = fso.OpenTextFile(logFileName, ForAppending)
	    End If
	    'stream.WriteLine (FormatDateTime(Now()) & "|" & msg)
	    stream.WriteLine msg
	End Sub

End Class

