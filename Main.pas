unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  BASS, BASSenc, BASSenc_Opus, BASSOpus;

type
  TMainForm = class(TForm)
    btnStartMicSaveOpusStream: TButton;
    btnStopMicSaveOpusFile: TButton;
    btnPlayOpusFile: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStopMicSaveOpusFileClick(Sender: TObject);
    procedure btnStartMicSaveOpusStreamClick(Sender: TObject);
    procedure btnPlayOpusFileClick(Sender: TObject);
  private
    AudioStream: TMemoryStream;
    procedure StopChannels;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Enc: HENCODE = 0;
  Chan: HSTREAM = 0;
  ChanMic: HRECORD = 0;

const
  OpusFile: PChar = 'Test.opus';

implementation

{$R *.fmx}

function Mic_RecordOpus(channel: HRECORD; buffer: Pointer; Length: DWORD; user: Pointer): BOOL; stdcall;
begin
  Result:= True;
end;

procedure RecordOpusStream(channel: HENCODE; chan:DWORD;buffer: Pointer; len:DWORD; user: Pointer); stdcall;
begin
  MainForm.AudioStream.Write(Buffer^, len);
end;

procedure TMainForm.StopChannels;
begin
  if Enc <> 0 then
  begin
    BASS_ChannelStop(Enc);
    BASS_StreamFree(Enc);
    Enc:= 0;
  end;
  if ChanMic <> 0 then
  begin
    BASS_ChannelStop(ChanMic);
    BASS_StreamFree(ChanMic);
    ChanMic:= 0;
  end;
  if Chan <> 0 then
  begin
    BASS_ChannelStop(Chan);
    BASS_StreamFree(Chan);
    Chan:= 0;
  end;
end;

procedure TMainForm.btnPlayOpusFileClick(Sender: TObject);
begin
  StopChannels;
  Chan:= BASS_OPUS_StreamCreateFile(False, OpusFile, 0, 0, BASS_STREAM_AUTOFREE); // Use BASS_STREAM_DECODE to get PCM data
  if Chan = 0 then
    ShowMessage('Error playing opus file: ' + BASS_ErrorGetCode.ToString)
  else
    if not BASS_ChannelPlay(Chan, True) then
      ShowMessage('Error playing opus file: ' + BASS_ErrorGetCode.ToString);
end;

procedure TMainForm.btnStartMicSaveOpusStreamClick(Sender: TObject);
begin
  StopChannels;
  btnStartMicSaveOpusStream.Enabled:= False;
  btnPlayOpusFile.Enabled:= False;
  ChanMic:= BASS_RecordStart(48000, 2, BASS_RECORD_PAUSE, @Mic_RecordOpus, nil);
  if ChanMic = 0 then
    ShowMessage('Error creating mic recording stream: ' + BASS_ErrorGetCode.ToString);
  Enc := BASS_Encode_OPUS_Start(ChanMic, '--bitrate 48 --cvbr --speech --comp 0 --raw --raw-rate 8000', BASS_ENCODE_AUTOFREE or BASS_UNICODE, @RecordOpusStream, nil); // ~ secs delay at UDP reception
  if Enc = 0 then
    ShowMessage('Error creating opus encoding stream: ' + BASS_ErrorGetCode.ToString);
  if BASS_ChannelPlay(ChanMic, False) = False then
    ShowMessage('Error playing mic recording stream: ' + BASS_ErrorGetCode.ToString);
  btnStopMicSaveOpusFile.Enabled:= True;
end;

procedure TMainForm.btnStopMicSaveOpusFileClick(Sender: TObject);
begin
  StopChannels;
  btnStopMicSaveOpusFile.Enabled:= False;
  AudioStream.SaveToFile(OpusFile);
  AudioStream.Clear;
  btnStartMicSaveOpusStream.Enabled:= True;
  btnPlayOpusFile.Enabled:= True;
end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopChannels;
  AudioStream.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if BASS_Init(-1, 48000, 0, 0, nil) then
  begin
    BASS_RecordInit(-1);
  end;
  AudioStream:= TMemoryStream.Create;
end;

end.
