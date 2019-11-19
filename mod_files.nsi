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
	NSISdl::download https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi AWSCLI.msi
	/*File AWSCLI64PY3.msi*/
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI.msi"'
	Goto endAWS
 ${Else}
    MessageBox MB_YESNO "Do dzialania potrzebne jest AWS CLI. Zainstalowac? " /SD IDYES IDNO endAWS
	NSISdl::download https://s3.amazonaws.com/aws-cli/AWSCLI32PY3.msi AWSCLI.msi
	/*File AWSCLI32PY3.msi*/
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI.msi"'
	Goto endAWS
 ${EndIf} 
 endAWS:
 SetOutPath $PROFILE\.aws
 File config
 File credentials
 
 SetOutPath $INSTDIR
 ExecWait "$INSTDIR\DB_download.bat"

SectionEnd
