Function ShowDialog()
	Dim dialog
	Set dialog = CreateObject("MSComDlg.CommonDialog")

	ShowDialog = ""

	dialog.DialogTitle = "CSV�t�@�C�����w��"
	dialog.Filter = "CSV�t�@�C��(*.csv)|*.csv|�S�t�@�C��(*.*)|*.*"
	dialog.Flags = &H80200
	dialog.InitDir = CreateObject("WScript.Shell").CurrentDirectory
	dialog.MaxFileSize = 256
	dialog.ShowOpen
	If Len(dialog.FileName) Then
	    ShowDialog = dialog.FileName
	End If
	Set dialog = Nothing
End Function

