for /f "delims=" %%i in ('slicer.exe example.inc "=" ";"') do set vers=%%i
echo %vers%