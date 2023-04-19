/*===============================================================================================================================================
|| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -||
||/ .----------------.  .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .----------------. \||
||/| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\||
||/| |   ______     | || |  ____  ____  | || |  _________   | || |     ____     | || | ____  _____  | || |     _____    | || |  ____  ____  | |\||
||/| |  |_   __ \   | || | |_   ||   _| | || | |_   ___  |  | || |   .'    `.   | || ||_   \|_   _| | || |    |_   _|   | || | |_  _||_  _| | |\||
||/| |    | |__) |  | || |   | |__| |   | || |   | |_  \_|  | || |  /  .--.  \  | || |  |   \ | |   | || |      | |     | || |   \ \  / /   | |\||
||/| |    |  ___/   | || |   |  __  |   | || |   |  _|  _   | || |  | |    | |  | || |  | |\ \| |   | || |      | |     | || |    > `' <    | |\||
||/| |   _| |_      | || |  _| |  | |_  | || |  _| |___/ |  | || |  \  `--'  /  | || | _| |_\   |_  | || |     _| |_    | || |  _/ /'`\ \_  | |\||
||/| |  |_____|     | || | |____||____| | || | |_________|  | || |   `.____.'   | || ||_____|\____| | || |    |_____|   | || | |____||____| | |\||
||/| |              | || |              | || |              | || |              | || |              | || |              | || |              | |\||
||/| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\||
||/ '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \||
|| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -||
|| ******************************************************** DEVELOPED BY |PHX| GHOST ********************************************************** ||
================================================================================================================================================*/
#include maps\mp\_utility;
#include phoenix\_common;

// 0 killer - splash8
// 1 head hunter - splash10
// 2 ninja - splash20
// 3 KD -splash2
// 4 dead man - splash14

init()
{
    phoenix\_events::addConnectEvent(::onConnect);

    level.endRecordsIcons["width"] = 80;
    level.endRecordsIcons["height"] = 80;

    // level waittill("ending_start");

    space = 25;
    offsetY = -150;
    nameOffsetY = -80;

    level.endRecords = [];
    shaders[0] = "splashicon8";
    shaders[1] = "splashicon10";
    shaders[2] = "splashicon20";
    shaders[3] = "splashicon2";
    shaders[4] = "splashicon14";

    // Killer
    level.endRecords[0]["icon"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], offsetY, shaders[0]);
    level.endRecords[0]["icon"].x = ((space * 2) + level.endRecordsIcons["width"] * 2) * -1;

    level.endRecords[0]["title"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -180, undefined);
    level.endRecords[0]["title"].x = ((space * 2) + level.endRecordsIcons["width"] * 2) * -1;
    level.endRecords[0]["title"].font = "default";
    level.endRecords[0]["title"].fontScale = 1.8;
    level.endRecords[0]["title"].color = (1, 1, 0);
    level.endRecords[0]["title"] setText("KILLER");

    level.endRecords[0]["value"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -100, undefined);
    level.endRecords[0]["value"].x = ((space * 2) + level.endRecordsIcons["width"] * 2) * -1;
    level.endRecords[0]["value"].font = "default";
    level.endRecords[0]["value"].fontScale = 2;

    level.endRecords[0]["name"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], nameOffsetY, undefined);
    level.endRecords[0]["name"].x = ((space * 2) + level.endRecordsIcons["width"] * 2) * -1;
    level.endRecords[0]["name"].font = "default";
    level.endRecords[0]["name"].fontScale = 1.6;

    // Head Hunter
    level.endRecords[1]["icon"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], offsetY, shaders[1]);
    level.endRecords[1]["icon"].x = (space + level.endRecordsIcons["width"] * 1) * -1;

    level.endRecords[1]["title"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -180, undefined);
    level.endRecords[1]["title"].x = (space + level.endRecordsIcons["width"] * 1) * -1;
    level.endRecords[1]["title"].font = "default";
    level.endRecords[1]["title"].fontScale = 1.8;
    level.endRecords[1]["title"].color = (1, 1, 0);
    level.endRecords[1]["title"] setText("HEAD HUNTER");

    level.endRecords[1]["value"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -100, undefined);
    level.endRecords[1]["value"].x = (space + level.endRecordsIcons["width"] * 1) * -1;
    level.endRecords[1]["value"].font = "default";
    level.endRecords[1]["value"].fontScale = 2;

    level.endRecords[1]["name"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], nameOffsetY, undefined);
    level.endRecords[1]["name"].x = (space + level.endRecordsIcons["width"] * 1) * -1;
    level.endRecords[1]["name"].font = "default";
    level.endRecords[1]["name"].fontScale = 1.6;

    // NINJA
    level.endRecords[2]["icon"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], offsetY, shaders[2]);
    level.endRecords[2]["icon"].x = 0;

    level.endRecords[2]["title"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -180, undefined);
    level.endRecords[2]["title"].x = 0;
    level.endRecords[2]["title"].font = "default";
    level.endRecords[2]["title"].fontScale = 1.8;
    level.endRecords[2]["title"].color = (1, 1, 0);
    level.endRecords[2]["title"] setText("NINJA");

    level.endRecords[2]["value"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -100, undefined);
    level.endRecords[2]["value"].x = 0;
    level.endRecords[2]["value"].font = "default";
    level.endRecords[2]["value"].fontScale = 2;

    level.endRecords[2]["name"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], nameOffsetY, undefined);
    level.endRecords[2]["name"].x = 0;
    level.endRecords[2]["name"].font = "default";
    level.endRecords[2]["name"].fontScale = 1.6;

    // KD
    level.endRecords[3]["icon"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], offsetY, shaders[3]);
    level.endRecords[3]["icon"].x = space + level.endRecordsIcons["width"] * 1;

    level.endRecords[3]["title"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -180, undefined);
    level.endRecords[3]["title"].x = space + level.endRecordsIcons["width"] * 1;
    level.endRecords[3]["title"].font = "default";
    level.endRecords[3]["title"].fontScale = 1.8;
    level.endRecords[3]["title"].color = (1, 1, 0);
    level.endRecords[3]["title"] setText("BEST K/D");

    level.endRecords[3]["value"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -100, undefined);
    level.endRecords[3]["value"].x = space + level.endRecordsIcons["width"] * 1;
    level.endRecords[3]["value"].font = "default";
    level.endRecords[3]["value"].fontScale = 2;

    level.endRecords[3]["name"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], nameOffsetY, undefined);
    level.endRecords[3]["name"].x = space + level.endRecordsIcons["width"] * 1;
    level.endRecords[3]["name"].font = "default";
    level.endRecords[3]["name"].fontScale = 1.6;

    // DEAD Man
    level.endRecords[4]["icon"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], offsetY, shaders[4]);
    level.endRecords[4]["icon"].x = (space * 2) + level.endRecordsIcons["width"] * 2;

    level.endRecords[4]["title"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -180, undefined);
    level.endRecords[4]["title"].x = (space * 2) + level.endRecordsIcons["width"] * 2;
    level.endRecords[4]["title"].font = "default";
    level.endRecords[4]["title"].fontScale = 1.8;
    level.endRecords[4]["title"].color = (1, 1, 0);
    level.endRecords[4]["title"] setText("DEAD MAN");

    level.endRecords[4]["value"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], -100, undefined);
    level.endRecords[4]["value"].x = (space * 2) + level.endRecordsIcons["width"] * 2;
    level.endRecords[4]["value"].font = "default";
    level.endRecords[4]["value"].fontScale = 2;

    level.endRecords[4]["name"] = recordHud(level.endRecordsIcons["width"], level.endRecordsIcons["height"], nameOffsetY, undefined);
    level.endRecords[4]["name"].x = (space * 2) + level.endRecordsIcons["width"] * 2;
    level.endRecords[4]["name"].font = "default";
    level.endRecords[4]["name"].fontScale = 1.6;

    level.records = [];
}

onConnect()
{
    for (;;)
    {
        level waittill("ending_start");

        self closeMenu();
        self closeInGameMenu();
        self setClientDvar("ui_hud_hardcore", 0);
        self notify("reset_outcome");
        self freezeControls(true);

        level.records[0]["value"] = 0;
        level.records[0]["name"] = "";
        level.records[1]["value"] = 0;
        level.records[1]["name"] = "";
        level.records[2]["value"] = 0;
        level.records[2]["name"] = "";
        level.records[3]["value"] = 0;
        level.records[3]["name"] = "";
        level.records[4]["value"] = 0;
        level.records[4]["name"] = "";

        for (i = 0; i < level.players.size; i++)
        {
            player = level.players[i];

            player.kd = 0;

            if (player.pers["deaths"] > 0)
                player.kd = int(player.pers["kills"] / player.pers["deaths"]);
            else
                player.kd = int(player.pers["kills"] / 1);

            if(!isDefined(player.pers["meleeKills"]))
                player.pers["meleeKills"] = 0;

            if (player.pers["kills"] > level.records[0]["value"])
            {
                level.records[0]["value"] = player.pers["kills"];
                level.records[0]["name"] = player.name;
            }

            if (player.pers["headshots"] > level.records[1]["value"])
            {
                level.records[1]["value"] = player.pers["headshots"];
                level.records[1]["name"] = player.name;
            }

            if (player.kd > level.records[3]["value"])
            {
                level.records[3]["value"] = player.kd;
                level.records[3]["name"] = player.name;
            }

            if (player.pers["deaths"] > level.records[4]["value"])
            {
                level.records[4]["value"] = player.pers["deaths"];
                level.records[4]["name"] = player.name;
            }

            if (player.pers["meleeKills"] > level.records[2]["value"])
            {
                level.records[2]["value"] = player.pers["meleeKills"];
                level.records[2]["name"] = player.name;
            }
        }

        for (i = 0; i < level.endRecords.size; i++)
        {

            if (isDefined(level.records[i]["value"]) && int(level.records[i]["value"]) > 0)
                level.endRecords[i]["value"] setText(level.records[i]["value"]);

            level.endRecords[i]["value"] fadeOverTime(1);
            level.endRecords[i]["value"].alpha = 1;
            level.endRecords[i]["value"] moveOverTime(1);
            level.endRecords[i]["value"].y = 0;

            level.endRecords[i]["icon"] fadeOverTime(1);
            level.endRecords[i]["icon"].alpha = 1;
            level.endRecords[i]["icon"] moveOverTime(1);
            level.endRecords[i]["icon"].y = -60;

            level.endRecords[i]["title"] fadeOverTime(1);
            level.endRecords[i]["title"].alpha = 1;
            level.endRecords[i]["title"] moveOverTime(1);
            level.endRecords[i]["title"].y = -120;

            if (isDefined(level.records[i]["name"]) && level.records[i]["name"] != "")
                level.endRecords[i]["name"] setText(level.records[i]["name"]);

            level.endRecords[i]["name"] fadeOverTime(1);
            level.endRecords[i]["name"].alpha = 1;
            level.endRecords[i]["name"] moveOverTime(1);
            level.endRecords[i]["name"].y = 20;
        }

        wait 20;
        level notify("ending_end");
    }
}

recordHud(width, height, offsetY, shader)
{
    endRecords = newHudElem();
    endRecords.y = offsetY;
    endRecords.alignX = "center";
    endRecords.alignY = "middle";
    endRecords.horzAlign = "center";
    endRecords.vertAlign = "middle";
    endRecords.alpha = 0;
    if (isDefined(shader))
        endRecords setShader(shader, width, height);
    else
        endRecords setText("___");

    return endRecords;
}