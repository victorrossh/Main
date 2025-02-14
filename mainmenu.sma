#include <amxmodx>
#include <main>
#include <hud>
#include <timer>
#include <timer_bot>
#include <medals>
#include <invis>
#include <shop>
#include <commands>

#define PLUGIN "Main menu"
#define VERSION "1.1"
#define AUTHOR "ftl~"

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);

	register_clcmd( "say /menu", "bhop_menu" ); 
	register_clcmd( "chooseteam", "bhop_menu" );
}

public plugin_natives(){
	register_library("mainmenu");
}


public client_putinserver(id)
{
	set_task(3.0, "bhop_menu", id);
}

public bhop_menu(id)
{
	new title[64];
	formatex(title, 63, "\r[FWO] \d- \wMain Menu");
	new menu = menu_create(title, "MenuHandler");
	
	menu_additem( menu, "\wStartpoint", "1");
	menu_additem( menu, "\wTop Menu", "2");
	menu_additem( menu, "\wCategories Menu", "3");
	menu_additem( menu, "\wBot Menu", "4");
	menu_additem( menu, "\wShop", "5");
	menu_additem( menu, "\wInvis Menu", "6");
	menu_additem( menu, "\wHud Menu", "7");
	menu_additem( menu, "\wMedals Menu", "8");
	menu_additem( menu, "\wHelp^n", "9");
	menu_additem( menu, "\wExit", "0");

	menu_setprop(menu, MPROP_PERPAGE, 0);

	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}

public MenuHandler(id , menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
 
	switch(item)
	{
		case 0: open_save_menu(id);
		case 1: open_top_menu(id);
		case 2: open_cat_menu(id);
		case 3: open_bot_menu(id);
		case 4: open_shop_menu(id);
		case 5: invis_menu(id);
		case 6: open_hud_menu(id);
		case 7: open_medals_menu(id);
		case 8: motd_commands(id);
		case 9:
		{
			menu_destroy(menu);
			return PLUGIN_HANDLED;
		}
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}