; example2.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install makensisw.exe into a directory that the user selects,
Function .onInit
  SetOutPath $TEMP
  File /oname=spltmp.bmp "..\flatbyte.bmp"

; optional
; File /oname=spltmp.wav "my_splashshit.wav"

  splash::show 1500 $TEMP\spltmp

  Pop $0 ; $0 has '1' if the user closed the splash screen early,
	 ; '0' if everything closed normal, and '-1' if some error occured.

  Delete $TEMP\spltmp.bmp
;  Delete $TEMP\spltmp.wav
FunctionEnd


;--------------------------------

;LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
;LangString Name ${LANG_GERMAN} "German"

; The name of the installer
Name "MSI Commando"

; The file to write
OutFile "MsiCommando.exe"

; The default installation directory
InstallDir $PROGRAMFILES\FlatByte\Commando

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\FlatByte\Commando" "Install_Dir"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "Programfiles (required)"
  SetShellVarContext all
  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File ".\commando.hta"
  File ".\mytree.js"
  File ".\msi2_absent.gif"
  File ".\msi2_advertise.gif"
  File ".\msi2_broken.gif"
  File ".\msi2_local.gif"
  File ".\msi2_source.gif"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\FlatByte\Commando "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "DisplayName" "MSI Commando"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "DisplayIcon" "$WINDIR\system32\osuninst.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "DisplayVersion" "1.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "Publisher" "FlatByte IT-Consulting"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "URLInfoAbout" "www.flatbyte.com"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\FlatByte"
  ;CreateShortCut "$SMPROGRAMS\FlatByte\MSI Commando\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\FlatByte\MSI Commando.lnk" "$INSTDIR\commando.hta" "" "$WINDIR\system32\osuninst.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  SetShellVarContext all  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiCommando"
  DeleteRegKey HKLM "SOFTWARE\FlatByte\Commando"
  DeleteRegKey HKCU "SOFTWARE\FlatByte\Commando"

  ; Remove files and uninstaller
  Delete $INSTDIR\commando.hta
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\mytree.js        
  Delete $INSTDIR\msi2_absent.gif  
  Delete $INSTDIR\msi2_advertise.gif
  Delete $INSTDIR\msi2_broken.gif  
  Delete $INSTDIR\msi2_local.gif   
  Delete $INSTDIR\msi2_source.gif  

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\FlatByte\MSI Command*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\FlatByte\MSI Commando"
  RMDir "$SMPROGRAMS\FlatByte"
  RMDir "$INSTDIR"

SectionEnd
