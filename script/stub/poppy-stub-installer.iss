; Minimal Inno Setup script for the Poppy stub installer.
; Mirrors the install shape of the upstream Warp installer
; (script/windows/windows-installer.iss) but with the heavy
; dependencies (conpty, OpenConsole, dxcompiler, resources/, mutex
; coordination) stripped — this is a placeholder until the real
; build lands.

#define MyAppName "Poppy"
#define MyAppPublisher "Poppy contributors"
#define MyAppURL "https://github.com/yanimeziani/poppy"
#define MyAppExeName "poppy.exe"
#ifndef MyAppVersion
  #define MyAppVersion "0.1.0-stub"
#endif
#ifndef Arch
  #define Arch "x64"
#endif
#ifndef OutputName
  #define OutputName "Poppy-Setup-x64-stub"
#endif
#ifndef PayloadDir
  #define PayloadDir "..\..\target-stub"
#endif
#define IconDir "..\..\app\channels\oss\icon\no-padding"

[Setup]
; Stable AppId so a future real-build installer upgrades the stub in place.
AppId=poppy-terminal-oss
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
UninstallDisplayName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
ArchitecturesAllowed={#Arch}
ArchitecturesInstallIn64BitMode={#Arch}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename={#OutputName}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile={#IconDir}\icon.ico
UninstallDisplayIcon={app}\icon.ico
CloseApplications=force
MinVersion=10.0.18362

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#PayloadDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#IconDir}\icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Poppy\{#MyAppName}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,Poppy}"; Flags: postinstall nowait skipifsilent

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  BinDir: string;
  CmdScriptPath: string;
  CmdScriptContent: string;
begin
  if CurStep = ssPostInstall then begin
    BinDir := ExpandConstant('{app}\bin');
    if not DirExists(BinDir) then
      CreateDir(BinDir);
    CmdScriptPath := BinDir + '\poppy.cmd';
    CmdScriptContent := '@echo off' + #13#10 +
                        '"' + ExpandConstant('{app}\{#MyAppExeName}') + '" %*' + #13#10;
    SaveStringToFile(CmdScriptPath, CmdScriptContent, False);
  end;
end;

[UninstallDelete]
Type: filesandordirs; Name: "{app}\bin"
