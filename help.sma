#include <amxmodx>

#define PLUGIN "Show MOTD"
#define VERSION "1.1"
#define AUTHOR "ftl~"

enum _:MOTDData{
    MotdURL[512],
    MotdName[64]
}

new const g_szLink[][MOTDData] = {
    {"http://140.238.182.239/teste/", "Help"}
}

public plugin_init(){
    register_plugin(PLUGIN, VERSION, AUTHOR);

    register_clcmd("say /comandos", "showCommands");
    register_clcmd("say /help", "showCommands");
}

public plugin_natives(){   
    register_library("commands");
    register_native("motd_commands", "native_motd_commands");
}

public native_motd_commands(numParams){
    new id = get_param(1);
    return showCommands(id);
}

public showCommands(id){
    show_motd(id, g_szLink[0][MotdURL], g_szLink[0][MotdName]);
    return PLUGIN_HANDLED;
}