@ECHO Off
cd ../../
start ./cod4x18_dedrun.exe +set sv_punkbuster 0 +set developer 1 +set dedicated 2 +set net_ip 0.0.0.0 +set net_port 28960 +set sv_maxclients 32 +exec server.cfg +map mp_killhouse +set fs_game "Mods/phx_promod" +set rcon_password "phx2k23123"