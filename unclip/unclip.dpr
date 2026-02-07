program ClipboardReader;

{$mode objfpc}{$H+}

{$APPTYPE CONSOLE}

uses
  Windows;

function GetClipboardText: string;   // ansi
var
  hClipboardData: HGLOBAL;
  pchData: PChar;
  DataLen: Integer;
begin
  Result := '';
  if OpenClipboard(0) then begin
    try
      hClipboardData := GetClipboardData(CF_TEXT);
      if hClipboardData <> 0 then begin
        pchData := GlobalLock(hClipboardData);
        if pchData <> nil then begin
          try
            DataLen := GlobalSize(hClipboardData) - 1;
            SetLength(Result, DataLen);
            Move(pchData^, Result[1], DataLen);
          finally
            GlobalUnlock(hClipboardData);
          end;
        end;
      end;
    finally
      CloseClipboard;
    end;
  end;
end;

function GetClipboardTextUTF8: UTF8String;
var
  hClipboardData: HGLOBAL;
  pwszData: PWideChar;
  DataLen: Integer;
  WideStr: WideString;
begin
  Result := '';
  if OpenClipboard(0) then begin
    try
      hClipboardData := GetClipboardData(CF_UNICODETEXT);
      if hClipboardData <> 0 then begin
        pwszData := GlobalLock(hClipboardData);
        if pwszData <> nil then begin
          try
            DataLen := GlobalSize(hClipboardData) div SizeOf(WideChar) - 1;
            SetLength(WideStr, DataLen);
            Move(pwszData^, WideStr[1], DataLen * SizeOf(WideChar));
            Result := UTF8Encode(WideStr);
          finally
            GlobalUnlock(hClipboardData);
          end;
        end;
      end;
    finally
      CloseClipboard;
    end;
  end;
end;


var
  ClipboardContent: string;
  ClipboardContentUtf8: UTF8String;
  utf8: boolean;
begin
    utf8 := (ParamCount = 0) or (LowerCase(ParamStr(1)) <> 'ansi');
    
    if (ParamCount > 0) and ((ParamStr(1) = '/?') or (ParamStr(1) = '--help')) then begin
      WriteLn('unclip 1.3, dea 2021-2024');
      WriteLn('Clipboard redirection to stout, by default utf8');
      WriteLn('Using:');
      WriteLn('  unclip /?');
      WriteLn('  unclip > file.txt');
      WriteLn('  unclip utf8 > file.txt');
      WriteLn('  unclip ansi > file.txt');
      WriteLn('  unclip | sort | clip');
      WriteLn('  unclip.exe | wget.exe -i -');
      exit;
    end;

    if utf8 then begin
       ClipboardContentUtf8 := GetClipboardTextUTF8;
       SetTextCodePage(Output, CP_UTF8);
       WriteLn(ClipboardContentUtf8); // UTF8
    end
    else begin
       ClipboardContent := GetClipboardText;  // как читаем так и пишем, видимо
       WriteLn(ClipboardContent);   // ansi или oem в зависимости от входной кодировки как поняла из опыта
    end;
end.
