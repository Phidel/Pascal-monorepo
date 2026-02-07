@echo off
path=D:\fpcupdeluxe\fpc\bin\i386-win32\
fpc.exe -Fu"D:\lazdev\components\lazutils" -F"D:\lazdev\lcl\units\i386-win32" -vn- -Sa unclip.dpr || goto exit:

echo ----- 
unclip.exe

del *.o 2> nul

:exit