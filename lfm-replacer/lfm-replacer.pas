program LFMReplacer;

{$mode objfpc}{$H+}
{$codepage utf8}

uses
  LazUtf8, Classes, SysUtils, RegExpr;

type
  TComponentReplacement = record
    OldName: string;
    NewName: string;
  end;

const
  Replacements: array of TComponentReplacement = (
    (OldName: 'TJppBasicPanel'; NewName: 'TPanel'),
    (OldName: 'TApplicationEvents'; NewName: 'TApplicationProperties'),
    (OldName: 'TJPLazFloatSpinEdit'; NewName: 'TSpinEdit')
  );

procedure ReplaceInFile(const FileName: string);
var
  FileContents, temp: string;
  RegExpr: TRegExpr;
  i: Integer;
  Modified: Boolean;
begin
  Modified := False;
  RegExpr := TRegExpr.Create;
  try
    try
      // Загрузка всего файла как единой строки
      with TStringList.Create do
      try
        LoadFromFile(FileName);
        FileContents := Text;
      finally
        Free;
      end;

      // Проверка и замена для каждого компонента
      for i := 0 to Length(Replacements) - 1 do begin
        RegExpr.Expression := '\b' + Replacements[i].OldName + '\b';
        RegExpr.ModifierI := True;  // Регистронезависимый поиск
        
        temp := RegExpr.Replace(FileContents, Replacements[i].NewName, True);
        if temp <> FileContents then begin
          FileContents := temp;
          Modified := True;
        end;
      end;

      // Сохранение, если были изменения
      if Modified then begin
        with TStringList.Create do
        try
          Text := FileContents;
          SaveToFile(FileName);
        finally
          Free;
        end;
        WriteLn('Обработан файл: ', FileName);
      end;

    except
      on E: Exception do
        WriteLn('Ошибка при обработке файла ', FileName, ': ', E.Message);
    end;
  finally
    RegExpr.Free;
  end;
end;

procedure ProcessDirectory(const Directory: string);
var
  SearchRec: TSearchRec;
  FullPath: string;
begin
  if FindFirst(IncludeTrailingPathDelimiter(Directory) + '*.lfm', faAnyFile, SearchRec) = 0 then
  begin
    try
      repeat
        if (SearchRec.Attr and faDirectory) = 0 then begin
          FullPath := IncludeTrailingPathDelimiter(Directory) + SearchRec.Name;
          ReplaceInFile(FullPath);
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  end;
end;

var
  Directory: string;

begin
  if ParamCount < 1 then begin
    WriteLn('Использование: LFMReplacer <путь_к_директории>');
    Halt(1);
  end;

  Directory := ParamStr(1);

  // Проверка существования директории
  if not DirectoryExists(Directory) then begin
    WriteLn('Указанная директория не существует: ', Directory);
    Halt(1);
  end;

  WriteLn('Начало обработки файлов в директории: ', Directory);
  ProcessDirectory(Directory);
  WriteLn('Обработка завершена.');
end.
