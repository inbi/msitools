var fso = new ActiveXObject("Scripting.FileSystemObject");
var wsh = new ActiveXObject("WScript.Shell");
var installer = new ActiveXObject("WindowsInstaller.Installer");
var envTemp=wsh.ExpandEnvironmentStrings("%temp%");
var envWindir=wsh.ExpandEnvironmentStrings("%windir%");
objArgs = WScript.Arguments;

var msiFile = objArgs(0);
mf = fso.GetFile(msiFile);
stmp1=mf.Name
stmp2=stmp1.indexOf(".");
msiName=""+stmp1.substr(0,stmp2);

msi2File = mf.ParentFolder+"\\"+msiName+"_recab.msi";
mf.Copy(msi2File);
sLogFileName = envTemp+"\\"+msiName+"_recab.log";

WriteLogEntry("MSI Recab - (c)2005 by flatbyte.com");
WriteLogEntry("..processing package "+msiFile);

msiDb = installer.OpenDatabase(msiFile, 0);
msiView = msiDb.OpenView("SELECT * FROM _Streams");
msiView.Execute();
var iCC=0;
var aCC = new Array();

while(msiRecord = msiView.Fetch()) {
   var sStr=msiRecord.StringData(1)
   if(sStr.indexOf(".cab")>0||sStr.indexOf(".Cab")>0||sStr.indexOf(".CAB")>0) {
      aCC[iCC++]=sStr; // fuer spaeteres schreiben.

      sStrPath=mf.ParentFolder+"\\"+sStr;
      WriteLogEntry("..extracing "+sStr);
      var execStr="msidb.exe -d "+msiFile+" -x "+sStr;
      wsh.Run(execStr, 0, true);

      f = fso.GetFile(sStrPath);
      dVor=f.size;
      WriteLogEntry("..recompressing "+sStr+" -=- please wait..");

      var execStr="recomp.cmd "+sStr+" >>"+sLogFileName;
      wsh.Run(execStr, 0, true);

      dNach=f.size;
      dDiff=dVor - dNach;
      WriteLogEntry("..size before/after: "+dVor+"/"+dNach+" Bytes, Difference: "+dDiff+" Bytes");
      }
   }
msiView.Close();
delete(msiDb);

WriteLogEntry("..writing new file "+msi2File);
msiDb2 = installer.OpenDatabase(msi2File, 1);

for (i=0;i<iCC;i++) {
   try {
      msiView2 = msiDb2.OpenView("SELECT * FROM _Streams WHERE Name='"+aCC[i]+"'");
      msiView2.Execute();
      msiRecord = msiView2.Fetch();

      msiView2.Modify(6, msiRecord);
      msiRecord.ClearData();
      msiDb2.Commit();
      WriteLogEntry("..replacing "+aCC[i]);
      
      //msiRecord = msiView2.Fetch();
      msiRecord.StringData(1) = aCC[i];
      //msiRecord.SetStream(2, mf.ParentFolder+"\\"+aCC[i]);
      msiRecord.SetStream(2, aCC[i]);      
      msiView2.Modify(1, msiRecord);
      msiView2.Close();
      msiDb2.Commit();
      }
   catch(e) {
      WriteLogEntry("ERROR: "+e.description);
      }
   }
   /*
   for (i=0;i<iCC;i++) {
      WScript.Echo ("..replacing "+aCC[i]);
      msiRecord2=installer.CreateRecord(2);
      msiRecord2.SetStream(2, mf.ParentFolder+"\\"+aCC[i]);
      msiRecord2.SetStream(1, aCC[i]);
      msiView2.Modify(0, msiRecord2);
      msiView2.Execute(msiRecord2);
      }
   */
msiDb2.Commit();
WScript.Sleep(1000);
WriteLogEntry("all finished.");
wsh.LogEvent(4,"MSI Recab recompressed package "+msiFile+" successfully");

wsh.Run("notepad "+sLogFileName, 1, true);
if(wsh.Popup("CAB Dateien löschen?",10,"MSI Recab",32+4)==6) {
   wsh.Run("delcab.cmd "+mf.ParentFolder, 0, true);
   }


function WriteLogEntry(s) {
   // open/close fuer jeden logeintrag. zeitaufwendig, aber sicherer.
   var oFSO = new ActiveXObject("Scripting.FileSystemObject");
   var oFSOStream = oFSO.OpenTextFile(sLogFileName, 8, 1); // datei erstellen und anhaengen (create&append)
   var d = new Date();
   var sLog = d.toLocaleString()+" - "+s;
   oFSOStream.WriteLine(sLog);
   oFSOStream.Close();
   WScript.Echo(s);
   }

