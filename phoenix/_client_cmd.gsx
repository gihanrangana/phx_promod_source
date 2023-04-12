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

init() {

    addscriptcommand( "fov", 1 );
	addscriptcommand( "fps", 1 );
	addscriptcommand( "promod", 1 );
	addscriptcommand( "balance", 1 );

    setDvar( "client_cmd", "");

    for( ;; ){
        
        client_cmd = getDvar( "client_cmd" );

        if(client_cmd == "") {
            wait .05;
            continue;
        }
        
        data = strTok( client_cmd, ":" );

        if ( !isDefined(data[0]) || !isDefined(data[1]) )
            continue;
        
        command = data[0];
        player = getEntByNum( int(data[1]) );
        args = data[2];

        if(isDefined( player )) {

            if(!isCommandEnabled( command )){
                player iPrintLnBold("^1Client command^2 " + command + " ^7was disabled by ^1admin!");
            }else {
                player thread commandHandler( command, player, args);
            }
        }

        setDvar( "client_cmd", "");
    }
    
}

commandHandler( command, player, args ) {
    
    if(!isDefined( player ) || !isDefined( command ))
        return;

    if(!isDefined( self.pers["fps"]) || !isDefined( self.pers["fov"] || !isDefined( self.pers["promod"]) ))
        return;

    stat = undefined;

    switch(command) {
        case "fps":

            stat = self.pers["fps"];
            promod=false;

            if( self.pers["fps"] == 2 ){
                selfPrintBold( "Fullbright ^2[OFF] ^7" ); 
                stat = 1;

                if( promod ) {
                    self.pers[ "promod" ] = 2;
                    self setStat( 3002, 2 );
                    selfPrintBold( "Promod Vision ^2[ON] ^7" );
                }
            }else {

                if( self.pers["promod"] == 2 ){
                    promod=true;
                    self.pers[ "promod" ] = 1;
                    self setStat( 3002, 1 );
                    selfPrintBold( "Promod Vision ^2[OFF] ^7" );
                }

                selfPrintBold( "Fullbright ^2[ON] ^7" );
                stat = 2;
            }

            self.pers["fps"] = stat;
            self setStat( 3000, stat );

            break;
        case "fov":

            stat = self.pers["fov"];
            switch( self.pers["fov"] ){
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                    stat++;
                    selfPrintBold( "Fov Scale : ^2" + getFov( stat ) );
                    break;
                case 6:
                    stat = 1;                    
                    selfPrintBold( "Fov Scale : ^2" + getFov( stat ) );
                    break;
                default:
                    break;                    
            }

            self.pers["fov"] = stat;
            self setStat( 3001, stat );

            break;
        case "promod":
        
            stat = self.pers["promod"];
            fps = false;

            if( self.pers["fps"] == 2 ) {
                fps = true;
                self setStat( 3000, 1 );
                self.pers["fps"] = 1; 
                selfPrintBold( "Fullbright ^2[OFF] ^7" );
            }

            if( self.pers[ "promod" ] == 2 ){

                if( fps ){
                    self setStat( 3000, 2 );
                    self.pers["fps"] = 2; 
                    selfPrintBold( "Fullbright ^2[ON] ^7" );
                }

                stat = 1;
                self.pers[ "promod" ] = stat;
                self setStat( 3002, stat );
                selfPrintBold( "Promod Vision ^2[OFF] ^7" );
            }else {
                stat = 2;
                self.pers[ "promod" ] = stat;
                self setStat( 3002, stat );
                selfPrintBold( "Promod Vision ^2[ON] ^7" );
            }

            break;
        case "cgFov":
            stat = self.pers[ "cgFov" ];
            switch( self.pers[ "cgFov" ] ){
                case 1:
                case 2:
                case 3:
                    stat++;
                    break;
                case 4:
                    stat++;
                    break;
                default:
                    stat = 2;
                    break;
            }

            selfPrintBold( "cgFov: ^2" + getCgFov( stat ) +"^7" );
            self.pers[ "cgFov" ] = stat;
            self setStat( 3003, stat );
            
            break;
        case "tps":
            stat = self.pers["fps"];

            if( self.pers[ "tps" ] == 2 ) {
                stat = 1;
                selfPrintBold( "Third Person View ^2[OFF] ^7" ); 
            }else {
                stat = 2;
                selfPrintBold( "Third Person View ^2[ON] ^7" );
            }

            self.pers["tps"] = stat;
            self setStat( 3004, stat );

            break;
                
        case "balance":
        
            if(maps\mp\gametypes\_teams::getTeamBalance() == false) 
                player iPrintlnBold("^1Teams are already Balanced");
            else
                level maps\mp\gametypes\_teams::balanceTeams();

            break;
        default:
            stat = undefined;
            break;

    }

    if(isDefined(stat))
        self thread phoenix\_player::userSettings();
}

isCommandEnabled(command) {
    enabled_commands = getDvar( "phx_client_cmd" );

    // if (enabled_commands != "") {
    //     wait .05;
    //     self iPrintLnBold("^1Client commands was disabled by admin!");
    //     return false;
    // }

    enabled_commands = strTok( getDvar( "phx_client_cmd" ), "|" );

    enabled = true;
    for(i=0; i<enabled_commands.size; i++) {
        
        if( enabled_commands[ i ] == command ) {
            enabled = false;
        }
    }

    return enabled;
}