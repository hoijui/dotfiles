Dim sRet
Do While true
	inputStr = inputbox("��������(���͂Ȃ��̏ꍇ�͏I��)", "", sRet)
	If isEmpty(inputStr) Then Exit Do
	If inputStr = "" Then Exit Do
	sRet = test(inputStr)
Loop

Function test( inStr )
	Dim sRet
	test = sRet
End Function

