!include x64.nsh
Outfile "InstallName.exe"
 
 Page directory
 Page instfiles

Section


 
 SetOutPath $INSTDIR
 File DB_upload.bat
 File DB_download.bat
 ${If} ${RunningX64}
    MessageBox MB_YESNO "Do dzialania potrzebne jest AWS CLI. Zainstalowac? " /SD IDYES IDNO endAWS
	File AWSCLI64PY3.msi
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI64PY3.msi"'
	Goto endAWS
 ${Else}
    MessageBox MB_YESNO "Do dzialania potrzebne jest AWS CLI. Zainstalowac? " /SD IDYES IDNO endAWS
	File AWSCLI32PY3.msi
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI32PY3.msi"'
	Goto endAWS
 ${EndIf} 
 endAWS:
 SetOutPath $PROFILE\.aws
 File config
 File credentials
 
 SetOutPath $INSTDIR
 ExecWait "$INSTDIR\DB_download.bat"

SectionEnd
