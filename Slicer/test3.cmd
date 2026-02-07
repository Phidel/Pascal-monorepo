slicer.exe example.inc "=" ";" > slice.tmp
set /p vers=<slice.tmp
del slice.tmp
echo %vers%