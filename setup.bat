@echo OFF

cd %~dp0
for %%i in (.vimperatorrc .vimperatorrc.js) do copy %~dp0%%i %HOME%\%%i
for /F %%i in ('dir /A:D-S /b .*') do if not %%i == .git mklink /D %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:D-S /b _*') do if not %%i == .git mklink /D %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:A-S /b .*') do if not %%i == .git mklink    %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:A-S /b _*') do if not %%i == .git mklink    %HOME%\%%i %~dp0%%i
echo please execute under commands
echo git submodule init
echo git submodule update
mkdir .vim\bundle\errormarker.vim\doc
pause
goto :EOF
