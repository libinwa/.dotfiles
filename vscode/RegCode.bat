@echo off && setlocal enabledelayedexpansion

echo Settings for using VS Code portable edition.

:: Check administrator
REM >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM
REM if '%errorlevel%' NEQ '0' (
REM     goto UACPrompt
REM ) else (
REM     goto gotAdmin
REM )
REM
REM :UACPrompt
REM     echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
REM     echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
REM     "%temp%\getadmin.vbs"
REM     exit /B
REM
REM :gotAdmin
REM     if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
REM     pushd "%CD%"
REM     cd /d "%~dp0"

:begin
cls
color 0a

:start
set CODEHOME=%~dp0
set CODEHOME=%CODEHOME:~0,-1%
set DATETIME=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
for /f "tokens=2 delims==" %%a in ('path') do (
    set "str=%%a"
    set str=!str: =+!
    for %%i in (!str!) do (
        set "var=%%i"
        set var=!var:+= !
        echo !var!>>change.txt
        for /f "delims=" %%i in ('findstr "VS Code" change.txt') do set var=%%i
    )
)
del /q change.txt


echo #####################################################
echo # 1. Reg Code  2. Unreg Code  3. Reg Query  4. Quit #
echo #                                                   #
echo #                                                   #
echo #####################################################
set /p choice=Please select:
if .%choice%==.1 (
    goto addRegedit
) else if .%choice%==.2 (
    goto delRegedit
) else if .%choice%==.3 (
    goto queryRegedit
) else if .%choice%==.4 (
    goto end
) else (
    goto start
)

:end
exit


:addRegedit
REG ADD "HKCR\*\shell\VSCode"
REG ADD "HKCR\*\shell\VSCode" /ve /t REG_SZ /d "Open with Code" /f
REG ADD "HKCR\*\shell\VSCode" /v Icon /t REG_SZ /d "%CODEHOME%\Code.exe" /f
REG ADD "HKCR\*\shell\VSCode\command"
REG ADD "HKCR\*\shell\VSCode\command" /ve /t REG_SZ /d "\"%CODEHOME%\Code.exe\" \"%%1\"" /f

REG ADD "HKCR\Directory\shell\VSCode"
REG ADD "HKCR\Directory\shell\VSCode" /ve /t REG_SZ /d "Open with Code" /f
REG ADD "HKCR\Directory\shell\VSCode" /v Icon /t REG_SZ /d "%CODEHOME%\Code.exe" /f
REG ADD "HKCR\Directory\shell\VSCode\command"
REG ADD "HKCR\Directory\shell\VSCode\command" /ve /t REG_SZ /d "\"%CODEHOME%\Code.exe\" \"%%V\"" /f

REG ADD "HKCR\Directory\Background\shell\VSCode"
REG ADD "HKCR\Directory\Background\shell\VSCode" /ve /t REG_SZ /d "Open with Code" /f
REG ADD "HKCR\Directory\Background\shell\VSCode" /v Icon /t REG_SZ /d "%CODEHOME%\Code.exe" /f
REG ADD "HKCR\Directory\Background\shell\VSCode\command"
REG ADD "HKCR\Directory\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CODEHOME%\Code.exe\" \"%%V\"" /f
goto start

:queryRegedit
REG QUERY "HKCR\*\shell\VSCode" /ve
REG QUERY "HKCR\*\shell\VSCode" /v Icon
REG QUERY "HKCR\*\shell\VSCode\command" /ve

REG QUERY "HKCR\Directory\shell\VSCode" /ve
REG QUERY "HKCR\Directory\shell\VSCode" /v Icon
REG QUERY "HKCR\Directory\shell\VSCode\command" /ve

REG QUERY "HKCR\Directory\Background\shell\VSCode" /ve
REG QUERY "HKCR\Directory\Background\shell\VSCode" /v Icon
REG QUERY "HKCR\Directory\Background\shell\VSCode\command" /ve
goto start


:delRegedit
set /p answer= Delete Code from reg (y/n)?
if .%answer%==.y (
    REG DELETE "HKCR\*\shell\VSCode\command" /f
    REG DELETE "HKCR\*\shell\VSCode" /f
    REG DELETE "HKCR\Directory\shell\VSCode\command" /f
    REG DELETE "HKCR\Directory\shell\VSCode" /f
    REG DELETE "HKCR\Directory\Background\shell\VSCode\command" /f
    REG DELETE "HKCR\Directory\Background\shell\VSCode" /f
    goto start
) else (
    goto start
)

