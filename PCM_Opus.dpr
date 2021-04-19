program PCM_Opus;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  bass in 'Lib\bass.pas',
  bassenc in 'Lib\bassenc.pas',
  bassenc_opus in 'Lib\bassenc_opus.pas',
  bassopus in 'Lib\bassopus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
