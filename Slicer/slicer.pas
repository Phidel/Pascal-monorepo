program Slicer;
var
  filename, startMark, endMark: string;
  f: TextFile;
  line, slice: string;
  startPos, endPos: Integer;
  All: Boolean = false;
begin
  // Проверка параметров
  // выдает первое вхождение. Если указан параметр /all - все вхождения
  if ParamCount < 3 then begin
    WriteLn('Usage: slicer.exe filename startMarker endMarker [/all]');
    Exit;
  end;
  
  filename := ParamStr(1);
  startMark := ParamStr(2);
  endMark := ParamStr(3);
  if LowerCase(ParamStr(4)) = '/all' then
    all := True; 
  
  AssignFile(f, filename);
  try
    Reset(f);
    while not Eof(f) do begin
       ReadLn(f, line);
       
       startPos := Pos(startMark, line);
       while startPos > 0 do begin
         startPos := startPos + Length(startMark);
         endPos := Pos(endMark, line, startPos);
         if endPos > 0 then begin
           slice := Copy(line, startPos, endPos - startPos);
           Write(slice);  // без WriteLn чтобы не было переноса строки
           if not all then
             Break
           else
             writeln;
           startPos := Pos(startMark, line, endPos+Length(endMark));
         end
         else 
           startpos := 0;
       end;
    end;
  finally
    CloseFile(f);
  end;
end.