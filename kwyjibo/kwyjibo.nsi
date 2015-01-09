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
Name "MSI Kwyjibo"

; The file to write
OutFile "MsiKwyjibo.exe"

; The default installation directory
InstallDir $PROGRAMFILES\FlatByte\Kwyjibo

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\FlatByte\MSI Kwyjibo" "Install_Dir"

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
  File ".\kwyjibo.hta"
  File ".\mytree.js"
  File ".\tab.png"
  File ".\tab.active.png"
  File ".\tab.hover.png"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\FlatByte\Kwyjibo "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "DisplayName" "MSI Kwyjibo"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "DisplayIcon" "$WINDIR\system32\msi.dll"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "DisplayVersion" "0.9"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "Publisher" "FlatByte IT-Consulting"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "URLInfoAbout" "www.flatbyte.com"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\FlatByte"
  ;CreateShortCut "$SMPROGRAMS\FlatByte\MSI Kwyjibo\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\FlatByte\MSI Kwyjibo.lnk" "$INSTDIR\kwyjibo.hta" "" "$WINDIR\system32\msi.dll" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  SetShellVarContext all  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiKwyjibo"
  DeleteRegKey HKLM "SOFTWARE\FlatByte\Kwyjibo"
  DeleteRegKey HKCU "SOFTWARE\FlatByte\Kwyjibo"

  ; Remove files and uninstaller
  Delete $INSTDIR\kwyjibo.hta
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\mytree.js        
  Delete $INSTDIR\tab.png      
  Delete $INSTDIR\tab.active.png
  Delete $INSTDIR\tab.hover.png

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\FlatByte\MSI Kwyjib*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\FlatByte\MSI Kwyjibo"
  RMDir "$SMPROGRAMS\FlatByte"
  RMDir "$INSTDIR"

SectionEnd
