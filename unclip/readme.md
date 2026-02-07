# unclip

redirect clipboard to stout - выводит содержание буфера обмена на консоль

поддержка utf8 (by default), ansi

https://stackoverflow.com/questions/26255148/is-writeln-capable-of-supporting-unicode

см также аналоги `G:\Files\Utilities\Clipboard\clipboard`


----


## Usage

``` bash
  unclip.exe /?

  unclip > file.txt
  unclip utf8 > file.txt
  unclip ansi > file.txt
```

Отсортировать строки в буфере обмена
``` bash
unclip.exe | sort | clip 
```

Скачать ссылки, находящиеся в буфере обмена:

```bash
@echo off
color 0A
cls
 
unclip.exe | wget.exe -i - 
 
echo.
echo Press any key to exit.
pause >nul
```

----

`uclip` - обратная команда к системной команде `clip` - поместить в буфер обмена. 

`clip` перенаправляет вывод от утилит командной строки в буфер обмена Windows.

Примеры:
```bash
DIR | CLIP         # Помещает список содержимого текущей папки в буфер обмена
CLIP < README.TXT  # Помещает копию текста из файла readme.txt в буфер обмена 
```



## History

### 1.2 11.01.2022

-  увеличила буфер с 16 до 64 кб
-  по умолчанию теперь utf8, а не анси
-  добавлен ключ ansi 

### 1.3 2024-10-11

-  переписано на лазарус
-  нет ограничений на размер буфера
-  не используется Clipbrd, размер exe из-за этого сильно уменьшился - 40960 байт
