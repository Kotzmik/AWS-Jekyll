/*
All files that are being deployed in this installation have to be in the same folder as this file while building the installation exe
*/
!include x64.nsh
Outfile "InstallName.exe"  
 
 Page directory
 Page instfiles

Section


 
 SetOutPath $INSTDIR
 File upload.bat		;deploy download and upload scripts in the install directory
 File download.bat
 ${If} ${RunningX64} 	;part of code responsible to determine the version of the system, download proper awscli version and istall it
    MessageBox MB_YESNO "You need AWS CLI installed for the scripts to properly work. Do you wish to install? " /SD IDYES IDNO endAWS
	NSISdl::download https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi AWSCLI.msi
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI.msi"'
	Goto endAWS
 ${Else}
    MessageBox MB_YESNO "You need AWS CLI installed for the scripts to properly work. Do you wish to install? " /SD IDYES IDNO endAWS
	NSISdl::download https://s3.amazonaws.com/aws-cli/AWSCLI32PY3.msi AWSCLI.msi
	ExecWait '"msiexec" /I "$INSTDIR\AWSCLI.msi"'
	Goto endAWS
 ${EndIf} 
 endAWS:
	 
 SetOutPath $PROFILE\.aws 	;go to aws config files and deploy config and credentials
 File config
 File credentials
 
 SetOutPath $INSTDIR	;go back to install directory and run download.bat
 ExecWait "$INSTDIR\download.bat"	;runs download script from the bucket to get the website project

SectionEnd
