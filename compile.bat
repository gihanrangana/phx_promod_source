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
echo    3. Copy
echo    4. Start
echo.
echo    0. Exit
echo -----------------------------------------------------------------
echo.
set /p make_option=:
set make_option=%make_option:~0,1%
if "%make_option%"=="1" goto build_ff
if "%make_option%"=="2" goto build_iwd
if "%make_option%"=="3" goto copyFiles
if "%make_option%"=="4" goto startGame
if "%make_option%"=="0" goto FINAL
goto :MAKEOPTIONS
:build_iwd
cls
cd %work_directory%

del ..\%mod_name%\*.iwd
del ..\%mod_name%\*.gsx

7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip ..\%mod_name%\%mod_name%_weapons.iwd weapons
7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip ..\%mod_name%\%mod_name%_images.iwd images
7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip ..\%mod_name%\%mod_name%_sound.iwd sound
7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip ..\%mod_name%\z_c_r.iwd promod_ruleset

echo -----------------------------------------------------------------
pause
goto :MAKEOPTIONS
:build_ff
cls
cd %work_directory%
echo    Copying rawfiles...
xcopy shock ..\..\raw\shock /SYI > NUL
xcopy images ..\..\raw\images /SYI > NUL
xcopy materials ..\..\raw\materials /SYI > NUL
xcopy material_properties ..\..\raw\material_properties /SYI > NUL
xcopy sound ..\..\raw\sound /SYI > NUL
xcopy soundaliases ..\..\raw\soundaliases /SYI > NUL
xcopy fx ..\..\raw\fx /SYI > NUL
xcopy mp ..\..\raw\mp /SYI > NUL
xcopy mp ..\..\zone_source\mp /SYI > NUL
xcopy weapons\mp ..\..\raw\weapons\mp /SYI > NUL
xcopy xanim ..\..\raw\xanim /SYI > NUL
xcopy xmodel ..\..\raw\xmodel /SYI > NUL
xcopy xmodelparts ..\..\raw\xmodelparts /SYI > NUL
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SYI > NUL
xcopy ui ..\..\raw\ui /SYI > NUL
xcopy ui_mp ..\..\raw\ui_mp /SYI > NUL
xcopy english ..\..\raw\english /SYI > NUL
xcopy vision ..\..\raw\vision /SYI > NUL
xcopy rumble ..\..\raw\rumble /SYI > NUL
xcopy animtrees ..\..\raw\animtrees /SYI > NUL

echo    Copying source code...
xcopy maps ..\..\raw\maps /SYI > NUL
xcopy promod ..\..\raw\promod /SYI > NUL

echo    Copying MOD.CSV...
xcopy mod.csv ..\..\zone_source /SYI > NUL

cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod -verbose

cd ..\mods\phx_promod
copy ..\..\zone\english\mod.ff

echo -----------------------------------------------------------------
pause
goto :MAKEOPTIONS
:copyFiles
cls
@echo Coping gsx files...
xcopy /E /I ..\phx_promod_source\phoenix\ ..\phx_promod\phoenix /Y
xcopy /E /I ..\phx_promod_source\maps\ ..\phx_promod\maps /Y

echo -----------------------------------------------------------------
pause
goto :MAKEOPTIONS
:startGame
cls
cd ../../
start ./cod4x18_dedrun.exe +set sv_punkbuster 0 +set developer 1 +set dedicated 2 +set net_ip 0.0.0.0 +set net_port 28960 +set sv_maxclients 32 +exec server.cfg +map mp_killhouse +set fs_game "Mods/phx_promod" +set rcon_password "pxh2k23123" +set r_xassetnum "xmodel=1200"

goto :MAKEOPTIONS
:FINAL
cd %work_directory%
@echo Coping gsx files...
xcopy /E /I ..\phx_promod_source\phoenix\ ..\phx_promod\phoenix /Y
xcopy /E /I ..\phx_promod_source\maps\ ..\phx_promod\maps /Y
exit