program CutVideo;

uses
  SysUtils, Process;

function FindSecondColon(const s: string): Integer;
var
  i, count, Result: Integer;
begin
  count := 0;
  Result := 0;
  for i := 1 to Length(s) do
  begin
    if s[i] = ':' then
    begin
      Inc(count);
      if count = 2 then
      begin
        Result := i;
        FindSecondColon := Result;
        Exit;
      end;
    end;
  end;
end;

procedure resolveParam(param: string; var seconds: Integer);
var
  p1, p2: Integer;
  hStr, mStr, sStr: string;
  h, m, s: Integer;
begin
  h := 0; m := 0; s := 0;

  if Pos(':', param) = 0 then
  begin
    seconds := StrToInt(param);
    Exit;
  end;

  p1 := Pos(':', param);
  if p1 = 0 then
  begin
    Writeln('Formato inválido, debe ser mm:ss o hh:mm:ss (ej: 1:30 o 01:02:30)');
    Halt(1);
  end;

  p2 := FindSecondColon(param);

  if p2 = 0 then
  begin
    // formato mm:ss
    mStr := Copy(param, 1, p1-1);
    sStr := Copy(param, p1+1, Length(param)-p1);
    m := StrToInt(mStr);
    s := StrToInt(sStr);
  end
  else
  begin
    // formato hh:mm:ss
    hStr := Copy(param, 1, p1-1);
    mStr := Copy(param, p1+1, p2-p1-1);
    sStr := Copy(param, p2+1, Length(param)-p2);
    h := StrToInt(hStr);
    m := StrToInt(mStr);
    s := StrToInt(sStr);
  end;

  seconds := h * 3600 + m * 60 + s;
end;

var
  FileName, InputFile, OutputFile, BaseName, Ext: string;
  StartStr, EndStr: string;
  StartSec, EndSec, Duration: Integer;
  FFmpegCmd: TProcess;
begin
  if ParamCount < 3 then
  begin
    Writeln('Uso: ', ExtractFileName(ParamStr(0)), ' <inicio mm:ss|hh:mm:ss> <fin mm:ss|hh:mm:ss> <archivo>');
    Writeln('Ejemplo: ', ExtractFileName(ParamStr(0)), ' 1:30 1:35 "video.mp4"');
    Halt(1);
  end;

  FileName := ParamStr(3);
  StartStr := ParamStr(1);
  EndStr := ParamStr(2);

  // convertir tiempos
  resolveParam(StartStr, StartSec);
  resolveParam(EndStr, EndSec);

  if EndSec <= StartSec then
  begin
    Writeln('El tiempo de fin debe ser mayor al de inicio.');
    Halt(1);
  end;

  Duration := EndSec - StartSec;

  InputFile := FileName;
  BaseName := ChangeFileExt(FileName, '');
  Ext := ExtractFileExt(FileName);
  if Ext = '' then
    Ext := '.mkv';  // si no tiene extensión, ponemos mkv por defecto

  OutputFile := BaseName + '-cut' + Ext;

  // ejecutar ffmpeg
  FFmpegCmd := TProcess.Create(nil);
    FFmpegCmd.Executable := 'ffmpeg';
    FFmpegCmd.Parameters.Add('-ss');
    FFmpegCmd.Parameters.Add(IntToStr(StartSec));
    FFmpegCmd.Parameters.Add('-i');
    FFmpegCmd.Parameters.Add(InputFile);
    FFmpegCmd.Parameters.Add('-t');
    FFmpegCmd.Parameters.Add(IntToStr(Duration));
    FFmpegCmd.Parameters.Add('-c');
    FFmpegCmd.Parameters.Add('copy');
    FFmpegCmd.Parameters.Add(OutputFile);

    FFmpegCmd.Options := [poWaitOnExit];
    FFmpegCmd.Execute;

    Writeln('Proceso finalizado. Archivo generado: ', OutputFile);
    FFmpegCmd.Free;
end.
