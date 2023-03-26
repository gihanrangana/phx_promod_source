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

        if(!isDefined( player )) continue;


        enabled_commands = getDvar( "phx_client_cmd" );

        if (enabled_commands == "") {
            wait .05;
            player iPrintLnBold("^1Client commands was disabled by admin!");
            continue;
        }

        enabled_commands = strTok( getDvar( "phx_client_cmd" ), "|" );

        // for(i=0; i<enabled_commands.size; i++) {
        //     logPrint("command: " + command + " - " + enabled_commands[i]);
        //     if( enabled_commands[ i ] == command ) {
        //         player thread commandHandler( command, player, args);
        //         continue;
        //     }else{
        //         player iPrintLnBold("^1Client command^2 " + command + " ^7was disabled by admin!");
        //     }
        // }

        setDvar( "client_cmd", "");
    }
    
}

commandHandler( command, player, args ) {
    
    if(!isDefined( player ) || !isDefined( command ))
        return;

    switch(command) {
        case "fps":
            self iPrintLnBold("FPS");
            break;
        case "fov":
            self iPrintLnBold("FOV");
            break;
        case "promod":
            self iPrintLnBold("PROMOD");
            break;
        default:
            break;

    }
}