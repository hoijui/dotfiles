Function BrowseFolder(root)
	Dim folder

	' �t�H���_�I���_�C�A���O��\��
	Set folder = CreateObject("Shell.Application") _
			.BrowseForFolder(0, "Select Folder", 1, root)

	' �I����e���擾
	If Not (folder Is Nothing) Then
		BrowseFolder = folder.Items.Item.Path
		Set folder = Nothing
	End If

End Function

