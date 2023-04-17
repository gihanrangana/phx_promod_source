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

#include phoenix\_common;

init()
{
    level thread phoenix\_events::addConnectEvent(::onConnect);
}

onConnect()
{
    self thread onMenuResponse();
}

onMenuResponse()
{
    self endon("disconnect");

    for (;;)
    {
        self waittill("menuresponse", menu, response);

        if (menu == "-1")
        {

            stat = undefined;

            switch (response)
            {
            case "fps":

                stat = self.pers["fps"];
                promod = false;

                if (self.pers["fps"] == 2)
                {
                    selfPrintBold("Fullbright ^2[OFF] ^7");
                    stat = 1;

                    if (promod)
                    {
                        self.pers["promod"] = 2;
                        self setStat(3002, 2);
                        selfPrintBold("Promod Vision ^2[ON] ^7");
                    }
                }
                else
                {

                    if (self.pers["promod"] == 2)
                    {
                        promod = true;
                        self.pers["promod"] = 1;
                        self setStat(3002, 1);
                        selfPrintBold("Promod Vision ^2[OFF] ^7");
                    }

                    selfPrintBold("Fullbright ^2[ON] ^7");
                    stat = 2;
                }

                self.pers["fps"] = stat;
                self setStat(3000, stat);

                break;
            case "fov":

                stat = self.pers["fov"];
                switch (self.pers["fov"])
                {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                    stat++;
                    selfPrintBold("Fov Scale : ^2" + getFov(stat));
                    break;
                case 6:
                    stat = 1;
                    selfPrintBold("Fov Scale : ^2" + getFov(stat));
                    break;
                default:
                    break;
                }

                self.pers["fov"] = stat;
                self setStat(3001, stat);

                break;
            case "promod":

                stat = self.pers["promod"];
                fps = false;

                if (self.pers["fps"] == 2)
                {
                    fps = true;
                    self setStat(3000, 1);
                    self.pers["fps"] = 1;
                    selfPrintBold("Fullbright ^2[OFF] ^7");
                }

                if (self.pers["promod"] == 2)
                {

                    if (fps)
                    {
                        self setStat(3000, 2);
                        self.pers["fps"] = 2;
                        selfPrintBold("Fullbright ^2[ON] ^7");
                    }

                    stat = 1;
                    self.pers["promod"] = stat;
                    self setStat(3002, stat);
                    selfPrintBold("Promod Vision ^2[OFF] ^7");
                }
                else
                {
                    stat = 2;
                    self.pers["promod"] = stat;
                    self setStat(3002, stat);
                    selfPrintBold("Promod Vision ^2[ON] ^7");
                }

                break;
            case "cgFov":
                stat = self.pers["cgFov"];
                switch (self.pers["cgFov"])
                {
                case 1:
                case 2:
                case 3:
                    stat++;
                    break;
                case 4:
                    stat = 1;
                    break;
                default:
                    stat = 2;
                    break;
                }

                selfPrintBold("cgFov: ^2" + getCgFov(stat) + "^7");
                self.pers["cgFov"] = stat;
                self setStat(3003, stat);

                break;
            case "tps":
                stat = self.pers["fps"];

                if (self.pers["tps"] == 2)
                {
                    stat = 1;
                    selfPrintBold("Third Person View ^2[OFF] ^7");
                }
                else
                {
                    stat = 2;
                    selfPrintBold("Third Person View ^2[ON] ^7");
                }

                self.pers["tps"] = stat;
                self setStat(3004, stat);

                break;
            default:
                stat = undefined;
                break;
            }

            if (isDefined(stat))
                self thread phoenix\_player::userSettings();
        }

        // if (menu == "player_settings")
        // {
        //     switch(response)
        //     {
        //         case ""
        //     }
        // }
    }
}