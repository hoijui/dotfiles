Function ShowMultiSelectDialog()
	Dim comDlg
	Dim retAry, aryFile, arySize
	Dim i

	Set comDlg = CreateObject("MSComDlg.CommonDialog")
	comDlg.MaxFileSize = 256
	'�����̃t�@�C���I�����G�N�X�v���[����
	comDlg.Flags = &H0200 or &H080000
	'comDlg.DialogTitle = "CSV�t�@�C�����w��"
	'comDlg.Filter = "CSV�t�@�C��(*.csv)|*.csv|MS-Office �t�@�C��(*.xls)(*.doc)|*.xls;*.doc|�S�t�@�C��(*.*)|*.*"
	'comDlg.InitDir = CreateObject("WScript.Shell").CurrentDirectory

	comDlg.ShowOpen()

	aryFile = split(comDlg.FileName, chr(0))
	arySize = UBound(aryFile) - 1
	If arySize < 0 Then
		arySize = 0
		ReDim retAry(0)
		retAry(0) = comDlg.Filename
	Else
		ReDim retAry(arySize)
		retAry(LBound(retAry)) = aryFile(LBound(aryFile))
		For i = LBound(aryFile) + 1 To UBound(aryFile)
			retAry(i - 1) = aryFile(LBound(aryFile)) & "\" & aryFile(i)
		Next
	End If

	ShowMultiSelectDialog = retAry
	'for i = lbound(retary) to ubound(retary)
	'	msg = msg & retary(i) & vblf
	'next
	'msgbox msg
End Function

