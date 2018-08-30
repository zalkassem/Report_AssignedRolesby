Set WshShell = CreateObject("WScript.Shell")
cmds=WshShell.RUN("im runreport --hostname=%MKSSI_HOST% --user=%MKSSI_USER% --port=%MKSSI_PORT% --issues=%MKSSI_ISSUE0% --param=username=%MKSSI_USER% -g """&WScript.Arguments(0)&"""", 0, False)
Set WshShell = Nothing