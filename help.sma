#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Show MOTD"
#define VERSION "1.0"
#define AUTHOR "ftl~"

enum _:dados
{
    PreviewCommands[256],
    MotdName[64]
}

new const g_szLink[][dados] = {
    {"http://140.238.182.239/teste/", "Help"}
}

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    register_clcmd("say /comandos", "showCommands");
    register_clcmd("say /help", "showCommands");
}

public plugin_natives()
{   
    register_library("commands")
    register_native("motd_commands", "display_commands");
}

public display_commands(numParams)
{
    new id = get_param(1);
    return showCommands(id);
}

public showCommands(id)
{
	new item = read_data(2);
	
	new motd[256], title[64];
	formatex(motd, charsmax(motd), "%s", g_szLink[item][PreviewCommands]);
	formatex(title, charsmax(title), "%s", g_szLink[item][MotdName]);

	show_motd(id, motd, title);
	return PLUGIN_HANDLED;
}
