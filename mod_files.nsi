/*
All files that are being deployed in this installation have to be in the same folder as this file while building the installation exe.
*/
!include x64.nsh
Outfile "InstallName.exe"  
 
 Page directory
 Page instfiles

Section


 
 SetOutPath $INSTDIR
 File upload.bat		;deploy download and upload sscripts in the install directory
 File download.bat
 ${If} ${RunningX64} ;part of code responsible to determine the version of the system and download proper awscli version
    MessageBox MB_YESNO "Do dzialania potrzebne jest AWS CLI. Zainstalowac? " /SD IDYES IDNO endAWS
	NSISdl::download https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi AWSCLI.msi
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI.msi"'
	Goto endAWS
 ${Else}
    MessageBox MB_YESNO "Do dzialania potrzebne jest AWS CLI. Zainstalowac? " /SD IDYES IDNO endAWS
	NSISdl::download https://s3.amazonaws.com/aws-cli/AWSCLI32PY3.msi AWSCLI.msi
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI.msi"'
	Goto endAWS
 ${EndIf} 
 endAWS:
	 
 SetOutPath $PROFILE\.aws 	;go to aws config files and deploy config and credentials
 File config
 File credentials
 
 SetOutPath $INSTDIR	;go back to install directory and run download.bat
 ExecWait "$INSTDIR\download.bat"

SectionEnd
