:: Copyright (c) 2009-2017 Andreas Göransson <andreas.goransson@gmail.com>
:: Copyright (c) 2009-2017 Indrek Ardel <indrek@ardel.eu>
::
:: This file is part of Call of Duty 4 Promod.
::
:: Call of Duty 4 Promod is licensed under Promod Modder Ethical Public License.
:: Terms of license can be found in LICENSE.md document bundled with the project.

@echo off

SET mod_name=phx_promod
SET work_directory=%~dp0

:MAKEOPTIONS
echo -----------------------------------------------------------------
echo  Please select an option:
echo    1. Build Fast File
echo    2. Build IWD File
echo.
echo    0. Exit
echo -----------------------------------------------------------------
echo.
set /p make_option=:
set make_option=%make_option:~0,1%
if "%make_option%"=="1" goto build_ff
if "%make_option%"=="2" goto build_iwd
if "%make_option%"=="0" goto FINAL
goto :MAKEOPTIONS
:build_iwd
cls
cd %work_directory%

del ..\%mod_name%\*.iwd
del ..\%mod_name%\*.gsx

7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip ..\%mod_name%\%mod_name%.iwd weapons images sound
7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip ..\%mod_name%\z_c_r.iwd promod_ruleset

echo -----------------------------------------------------------------
pause
goto :MAKEOPTIONS
:build_ff
cls
compile_fastfile.bat

goto :MAKEOPTIONS
:FINAL