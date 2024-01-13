@echo off

if '%1'=='' goto SHOW_USAGE
if '%2'=='' goto SHOW_USAGE
call :domake %~df1 %2
exit /b


::::::::::::::::::::::::::do make:::::::::::::::::::::::::::
:domake
rem Make the project with CMake
echo usage:
echo   make ^<path^> ^<[debug][release]^> 
echo.
echo   -- PROJECT_DIR: %1
echo   -- CONFIG_TYPE: %2
echo.
if NOT EXIST "%1" (
  echo Cannot find build path "%1"
  exit /b 1
)
if "%2" NEQ "debug" (
    if "%2" NEQ "release" (
      echo Invalid config type "%2"
      exit /b 1
    )
)

echo.
echo Check MSVC environment...
if "%DEFINED_MSVC%"=="" (
  echo Prepare MSVC environment...
  pushd %~dp0
  cd C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional\\VC\\Auxiliary\\Build
  if NOT EXIST "vcvarsall.bat" (
    @echo Cannot find "vcvarsall.bat", please check vs2022 compile environment.
    popd
    exit /b 1
  )
  set DEFINED_MSVC=vs2022
  call vcvarsall.bat x86_amd64
  popd
)
echo.
echo The following environment variables are used:
echo   -- MSVC: %DEFINED_MSVC%
echo   -- Platform: x86_amd64
echo.
rem CMAKE_<LANG>_COMPILER_ID: MSVC  | GNU  | Clang
set MAKE_OPTION_COMPILER=msvc
set MAKE_OPTION_GENERATOR=Ninja
set MAKE_OPTION_DEFINATIONS=

if EXIST "%DEVTOOLS%" (
  echo.
  echo   -- DEVTOOLS: %DEVTOOLS%
  echo.
  call %DEVTOOLS%\tool_cmake\prepare.bat
  set MAKE_OPTION_DEFINATIONS=-DCMAKE_TOOLCHAIN_FILE="%DEVTOOLS%\\tool_cmake\\addons\\modulesX\\Platform\\win-msvc-x64.cmake" -DMSC_REQ_ADAPTER=1
)

echo.
echo Generating...
set PROJECT_DIR=%1
set CONFIG_TYPE=%2
pushd %~dp0
cd %PROJECT_DIR%
set  SOURCE_ROOT=.
set INSTALL_ROOT=.\out\install
set   BUILD_ROOT=.\out\generated

if NOT EXIST "CMakeLists.txt" (
  echo Cannot find the top-level "CMakeList.txt", please check project configuration
  popd
  exit /b 1
)
set BUILD_PATH=%BUILD_ROOT%\%MAKE_OPTION_COMPILER%-%MAKE_OPTION_GENERATOR%\%CONFIG_TYPE%
set INSTALL_PATH=%INSTALL_ROOT%\\%CONFIGTYPE%
if NOT EXIST "%BUILD_PATH%" mkdir %BUILD_PATH%
if NOT EXIST "%INSTALL_PATH%" mkdir %INSTALL_PATH%
echo -------------------------------------------------------
echo configurate %CONFIG_TYPE%
echo -------------------------------------------------------
::cmake -S %SOURCE_ROOT% -B %BUILD_PATH% -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=%CONFIG_TYPE% -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH% -DCMAKE_EXPORT_COMPILE_COMMANDS=True %MAKE_OPTION_DEFINATIONS%
cmake -S %SOURCE_ROOT% -B %BUILD_PATH% -G "%MAKE_OPTION_GENERATOR%"  -DCMAKE_BUILD_TYPE=%CONFIG_TYPE% -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH% -DCMAKE_EXPORT_COMPILE_COMMANDS=True %MAKE_OPTION_DEFINATIONS%
if NOT errorlevel 0 (
  echo configuration errors found!!!
  popd
  exit /b 1
)
echo.
echo =======================================================
echo build %CONFIG_TYPE%
echo =======================================================
call :build %BUILD_PATH% %CONFIG_TYPE%
if errorlevel 0 (
  echo After build %CONFIG_TYPE%...
  if EXIST "%BUILD_PATH%\\compile_commands.json" (
    ::rsync -zahv  %BUILD_PATH%/compile_commands.json  %PROJECT_DIR%
    xcopy /F /Y %BUILD_PATH%\\compile_commands.json  %PROJECT_DIR%
  )
  echo.
  echo DONE.
)
popd
exit /b


:::::::::::::::::::::::::::private methods::::::::::::::::::::::::::::
:build
rem Build the project with CMake
echo usage:
echo   build ^<buildpath^> ^<[debug][release]^> 
echo.
echo build %1 %2
echo.
REM ##############################################################################
REM ### If there are some syntax errors, i.e.  error C2001: newline in constant, #
REM ### error C2143: syntax error: missing ';' before 'std::string',             #
REM ### try to change source file utf-8 -> utf-8 with BOM.                       #
REM ##############################################################################
if NOT EXIST "%1" (
  echo Cannot find build path "%1", please check your configuration
  exit /b 1
)
if "%2" NEQ "debug" (
    if "%2" NEQ "release" (
      echo Invalid config type "%2", please check your configuration
      exit /b 1
    )
)
set  BUILDPATH=%1
set CONFIGTYPE=%2
::cmake --build %BUILDPATH% --target INSTALL --config %CONFIGTYPE% -- /nologo /verbosity:minimal /maxcpucount
if '%MAKE_OPTION_GENERATOR%'=='Ninja' cmake --build %BUILDPATH% --target install --config %CONFIGTYPE%  -- -j 4
exit /b


::::::::::::::::::::::::::show information:::::::::::::::::::::::::::
:SHOW_USAGE
echo Script to do make workflow.
echo.
echo usage:
echo   make ^<project-path^> ^<[debug][release]^> 
echo.
echo Processing info is logged to stdout.
echo Detected issues are logged to stderr.
exit /b 1
