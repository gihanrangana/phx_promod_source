:: Copyright (c) 2009-2017 Andreas Göransson <andreas.goransson@gmail.com>
:: Copyright (c) 2009-2017 Indrek Ardel <indrek@ardel.eu>
::
:: This file is part of Call of Duty 4 Promod.
::
:: Call of Duty 4 Promod is licensed under Promod Modder Ethical Public License.
:: Terms of license can be found in LICENSE.md document bundled with the project.

@echo off

SET work_directory=%~dp0
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

@echo Coping gsx files...
xcopy /E /I ..\phx_promod_source\phoenix\ ..\phx_promod\phoenix /Y

exit
