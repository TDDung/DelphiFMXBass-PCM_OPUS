{
  BASSenc_OPUS 2.4 Delphi unit
  Copyright (c) 2016-2020 Un4seen Developments Ltd.

  See the BASSENC_OPUS.CHM file for more detailed documentation
}

Unit BASSenc_OPUS;

interface

{$IFDEF MSWINDOWS}
uses BASSenc, Windows;
{$ELSE}
uses BASSenc;
{$ENDIF}

const
  // BASS_Encode_OPUS_NewStream flags
  BASS_ENCODE_OPUS_RESET = $1000000;
  BASS_ENCODE_OPUS_CTLONLY = $2000000;

{$IFDEF MSWINDOWS}
  bassencopusdll = 'bassenc_opus.dll';
{$ENDIF}
{$IFDEF LINUX}
  bassencopusdll = 'libbassenc_opus.so';
{$ENDIF}
{$IFDEF ANDROID}
  bassencopusdll = 'libbassenc_opus.so';
{$ENDIF}
{$IFDEF MACOS}
  {$IFDEF IOS}
    bassencopusdll = 'libbassenc_opus.a';
  {$ELSE}
    bassencopusdll = 'libbassenc_opus.dylib';
  {$ENDIF}
{$ENDIF}

function BASS_Encode_OPUS_GetVersion: DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external bassencopusdll;

function BASS_Encode_OPUS_Start(handle:DWORD; options:PChar; flags:DWORD; proc:ENCODEPROC; user:Pointer): HENCODE; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external bassencopusdll;
function BASS_Encode_OPUS_StartFile(handle:DWORD; options:PChar; flags:DWORD; filename:PChar): HENCODE; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external bassencopusdll;
function BASS_Encode_OPUS_NewStream(handle:HENCODE; options:PChar; flags:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external bassencopusdll;

implementation

end.
