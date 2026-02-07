program Project1;
 
uses Windows;
 
function AddDataToClip(Format: UINT; const Data; Size: PtrUInt): Boolean;
var
  HMem: THandle;
  P: Pointer;
begin
  Result := False;
  HMem := GlobalAlloc(GMEM_MOVEABLE, Size);
  if HMem <> 0 then begin
    P := GlobalLock(HMem);
    if P <> nil then begin
      Move(Data, P^, Size);
      GlobalUnlock(HMem);
      Result := SetClipboardData(Format, HMem) <> 0;
    end;
  end;
end;
 
function PutTextToClipboard(const S: string): Boolean;
var
  W: UnicodeString;
begin
  Result := False;
  if OpenClipboard(0) then
  try
    if EmptyClipboard then begin
      W := UTF8Decode(S);
      Result := AddDataToClip(CF_UNICODETEXT, Pointer(W)^, SizeOf(UnicodeChar) * Length(W));
    end;
  finally
    CloseClipboard;
  end;
end;
 
begin
  PutTextToClipboard('привет' + #9 +'hello' + sLineBreak + 'buy.');
end.
