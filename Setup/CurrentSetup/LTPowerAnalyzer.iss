//This script will create the setup files for the LTpowerAnalyzer. Two files are created:
//1. SetupLTpowerAnalyzer - setup file that includes the drivers anad the LTpowerAnalyzer files
//2. UpdateLTpowerAnalyzer - setup file that only includes the LTpowerAnalyzer files

//If the keyword Setup is defined, the SetupLTpowerAnalyzer will be created, otherwise the UpdateLTpowerAnalyzer will be created.
//#define Setup
#define CurrentVersion "1.7.2.0"
#define MyAppName "LTpowerAnalyzer"
#define MyAppExeName "LTpowerAnalyzer.exe"

[Setup]
AppName=LTpowerAnalyzer
VersionInfoVersion= {#CurrentVersion}
DefaultDirName={commonpf}\LTpowerAnalyzer
DefaultGroupName=LTpowerAnalyzer
UninstallDisplayIcon={app}\LTpowerAnalyzer.exe
UninstallDisplayName = UninstallLTpowerAnalyzer
UninstallIconFile = UninstallLTpowerAnalyzer
ChangesAssociations = yes
OutputDir=.

#ifdef Setup
AppVerName=SetupLTpowerAnalyzer
OutputBaseFilename=SetupLTpowerAnalyzer
DisableProgramGroupPage = yes
DisableFinishedPage=no
#else
AppVerName=UpdateLTpowerAnalyzer
OutputBaseFilename=UpdateLTpowerAnalyzer
DisableProgramGroupPage = yes
DisableFinishedPage=yes
CloseApplications = true
#endif


[Code]
function InitializeSetup(): Boolean;
begin
  #ifdef Setup
  if (MsgBox(
  'This setup program will install LTpowerAnalyzer which is designed to run with the Analog Devices ADALM2000(M2K).'+ #13#10#13#10 
  + 'The following items will be installed if you click the OK button:' + #13#10
  + '1. M2K Drivers' + #13#10 
  + '2. ADI libm2k libraries (Uncheck all check boxes. Do not intall Python drivers or overwrite the existing libiio library)' + #13#10#13#10 
  + 'Do not restart your computer until all three installation programs have been run.'
  , mbInformation, MB_OKCANCEL) = IDOK) then
  begin
    Result := True;
  end else Result := False
  #else
  Result := True;
  #endif
end;


function PrepareToInstall(var NeedsRestart: Boolean): String;
var
ErrorCode: Integer;
ParameterString: String;
ProcessName: String;
TimeoutMilliSeconds : String;
begin
  //Close down the program if running using StopProcess.exe
  ProcessName :=  '{#SetupSetting("AppName")}';
  TimeoutMilliSeconds := '10000';
  ParameterString := ProcessName + ' ' + TimeoutMilliSeconds;
  ExtractTemporaryFile('StopProcess.exe');
  ShellExec('', ExpandConstant('{tmp}\StopProcess.exe'),ParameterString, '', SW_SHOW, ewWaitUntilTerminated, ErrorCode)
end;

#ifndef Setup
procedure CurStepChanged(CurStep: TSetupStep);
var
ErrorCode: Integer;
ParameterString: String;
ProcessName: String;
FileName: String;
begin

  if CurStep = ssPostInstall then
  begin
    //Launch the program if not running using StartProcess.exe
    ProcessName :=  '{#SetupSetting("AppName")}'; 
    FileName :=  '"' + ExpandConstant('{app}') + '\LTpowerAnalyzer.exe"';
    ParameterString := ProcessName + ' ' + FileName;
    ExtractTemporaryFile('StartProcess.exe');
    ShellExec('', ExpandConstant('{tmp}\StartProcess.exe'),ParameterString, '', SW_SHOW, ewWaitUntilTerminated, ErrorCode)
  end;
end;
#endif

[Messages]
#ifdef Setup
SetupAppTitle = Setup LTpowerAnalyzer {#CurrentVersion}
SetupWindowTitle = Setup LTpowerAnalyzer {#CurrentVersion}
#else
SetupAppTitle = Update LTpowerAnalyzer {#CurrentVersion}
SetupWindowTitle = Update LTpowerAnalyzer {#CurrentVersion}
#endif


[InstallDelete]
Type: files; Name: "{app}\LTpowerAnalyzer.exe"
Type: files; Name: "{app}\LTpowerAnalyzerDriver.dll"
Type: files; Name: "{app}\LTpowerAnalyzer.chm"
Type: files; Name: "{app}\LTpowerAnalyzerVersionHistory.txt"
Type: files; Name: "{app}\LTpowerAnalyzer.exe"
Type: files; Name: "{app}\LTpowerAnalyzerDriver.dll"
Type: files; Name: "{app}\LTpowerAnalyzer.chm"
Type: files; Name: "{app}\LTpowerAnalyzerExample.bod"
Type: files; Name: "{app}\PlutoSDR-M2k-USB-Drivers.exe"
Type: files; Name: "{app}\libm2k-0.3.2-Windows-setup.exe"

[Registry]
Root: HKCR; Subkey: ".bod"; ValueType: string; ValueName: ""; ValueData: "{#myAppName}"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#myAppName}"; ValueType: string; ValueName: ""; ValueData: "{#myAppName} Data File"; Flags: uninsdeletekey
Root: HKCR; Subkey: "{#myAppName}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0" 
Root: HKCR; Subkey: "{#myAppName}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

Root: HKCR; Subkey: ".bos"; ValueType: string; ValueName: ""; ValueData: "{#myAppName}2"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#myAppName}2"; ValueType: string; ValueName: ""; ValueData: "{#myAppName} Setup File"; Flags: uninsdeletekey
Root: HKCR; Subkey: "{#myAppName}2\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},1" 
Root: HKCR; Subkey: "{#myAppName}2\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

[Files]
Source: "StopProcess.exe"; flags: dontcopy
Source: "StartProcess.exe"; flags: dontcopy
Source: "C:\Projects\LTpowerAnalyzer\C#\LTpowerAnalyzerGUI\bin\Release\LTpowerAnalyzer.exe"; DestDir: "{app}"
Source: "C:\Projects\LTpowerAnalyzer\C#\LTpowerAnalyzerDriver\bin\Release\LTpowerAnalyzerDriver.dll"; DestDir: "{app}"
Source: "C:\Projects\LTpowerAnalyzer\C#\DLL\libm2k-sharp.dll"; DestDir: "{app}"
Source: "C:\Projects\LTpowerAnalyzer\C#\DLL\libm2k-sharp-cxx-wrap.dll"; DestDir: "{app}"

#ifdef Setup
Source: "..\CommonFiles\PlutoSDR-M2k-USB-Drivers.exe"; DestDir: "{app}";Flags: deleteafterinstall
Source: "..\CommonFiles\libm2k-0.3.2-Windows-setup.exe"; DestDir: "{app}";Flags: deleteafterinstall
#endif
Source: "LTpowerAnalyzer.chm"; DestDir: "{app}"
Source: "LTpowerAnalyzerVersionHistory.txt"; DestDir: "{app}"
Source: "LTpowerAnalyzerExample.bod"; DestDir: "{app}"

[Icons]
Name: "{commonprograms}\LTpowerAnalyzer\LTpowerAnalyzer"; Filename: "{app}\LTpowerAnalyzer.exe"
Name: "{commonprograms}\LTpowerAnalyzer\Uninstall LTpowerAnalyzer"; Filename: "{uninstallexe}"

[Run]
#ifdef Setup
Filename: "{app}\PlutoSDR-M2k-USB-Drivers.exe"; StatusMsg: "Installing M2K Driver";
Filename: "{app}\libm2k-0.3.2-Windows-setup.exe"; StatusMsg: "Installing libm2k. Uncheck the Python bindings boxes.";
#endif