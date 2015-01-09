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
Name "MSI ReCab"

; The file to write
OutFile "MsiReCab.exe"

; The default installation directory
InstallDir $PROGRAMFILES\FlatByte\ReCab

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\FlatByte\ReCab" "Install_Dir"

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
  File ".\recab.*"
  File ".\msidb.exe"
  File ".\cabarc.exe"
  File ".\*.cmd"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\FlatByte\ReCab "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "DisplayName" "MSI ReCab"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "DisplayIcon" "$WINDIR\system32\shell32,24"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "DisplayVersion" "1.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "Publisher" "FlatByte IT-Consulting"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "URLInfoAbout" "www.flatbyte.com"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  WriteRegStr HKCR "Msi.Package\shell\Recompress CAB\command" "" 'cmd.exe /c cscript.exe "$INSTDIR\recab.js" "%1"'

  ReadRegStr $1 HKLM "SYSTEM\ControlSet001\Control\Session Manager\Environment" "Path"
    StrCpy $2 $1 1 -1 # copy last char
    StrCmp $2 ";" 0 +2 # if last char == ;
      StrCpy $1 $1 -1 # remove last char
    StrCmp $1 "" AddToPath_NTdoIt
      StrCpy $0 "$1;$INSTDIR"
    AddToPath_NTdoIt:
      WriteRegExpandStr HKLM "SYSTEM\ControlSet001\Control\Session Manager\Environment" "Path" $0

  
  ;ReadRegStr $1 "SYSTEM\ControlSet001\Control\Session Manager\Environment" "Path"
  ;StrCpy $2 
  ;WriteRegStr HKLM "SYSTEM\ControlSet001\Control\Session Manager\Environment"

  CreateDirectory "$SMPROGRAMS\FlatByte"
  ;CreateShortCut "$SMPROGRAMS\FlatByte\MSI ReCab\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\FlatByte\MSI Recab Information.lnk" "http://www.flatbyte.com/products.msi.tools.recab.php" "" "" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  SetShellVarContext all  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MsiReCab"
  DeleteRegKey HKLM "SOFTWARE\FlatByte\ReCab"
  DeleteRegKey HKCR "Msi.Package\shell\Recompress CAB"

  ; Remove files and uninstaller
  Delete $INSTDIR\*.*

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\FlatByte\MSI ReCab*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\FlatByte\MSI ReCab"
  RMDir "$SMPROGRAMS\FlatByte"
  RMDir "$INSTDIR"

  ReadRegStr $1 HKLM "SYSTEM\ControlSet001\Control\Session Manager\Environment" "Path"
    StrCpy $5 $1 1 -1 # copy last char
    StrCmp $5 ";" +2 # if last char != ;
      StrCpy $1 "$1;" # append ;
    Push $1
    Push "$INSTDIR;"
    Call un.StrStr ; Find `$0;` in $1
    Pop $2 ; pos of our dir
    StrCmp $2 "" unRemoveFromPath_done
      ; else, it is in path
      # $0 - path to add
      # $1 - path var
      StrLen $3 "$INSTDIR;"
      StrLen $4 $2
      StrCpy $5 $1 -$4 # $5 is now the part before the path to remove
      StrCpy $6 $2 "" $3 # $6 is now the part after the path to remove
      StrCpy $3 $5$6

      StrCpy $5 $3 1 -1 # copy last char
      StrCmp $5 ";" 0 +2 # if last char == ;
        StrCpy $3 $3 -1 # remove last char

      WriteRegExpandStr HKLM "SYSTEM\ControlSet001\Control\Session Manager\Environment" "Path" $3

unRemoveFromPath_done:

SectionEnd

!macro StrStr un
Function ${un}StrStr
Exch $R1 ; st=haystack,old$R1, $R1=needle
  Exch    ; st=old$R1,haystack
  Exch $R2 ; st=old$R1,old$R2, $R2=haystack
  Push $R3
  Push $R4
  Push $R5
  StrLen $R3 $R1
  StrCpy $R4 0
  ; $R1=needle
  ; $R2=haystack
  ; $R3=len(needle)
  ; $R4=cnt
  ; $R5=tmp
  loop:
    StrCpy $R5 $R2 $R3 $R4
    StrCmp $R5 $R1 done
    StrCmp $R5 "" done
    IntOp $R4 $R4 + 1
    Goto loop
done:
  StrCpy $R1 $R2 "" $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
FunctionEnd
!macroend
!insertmacro StrStr ""
!insertmacro StrStr "un."


