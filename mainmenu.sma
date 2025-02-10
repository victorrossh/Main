#include <amxmodx>

#include <main>
#include <hud>
#include <timer>
#include <timer_bot>
#include <medals>
#include <invis>
#include <shop>

public plugin_init()
{
	register_plugin( "Menu", "1.1", "ftl~" );
	register_clcmd( "say /menu", "bhop_menu" ); 
	register_clcmd( "chooseteam", "bhop_menu" );
	register_clcmd("say /savemenu", "save_menu" );
}

public client_putinserver(id)
{
	set_task(3.0, "bhop_menu", id);
}

public bhop_menu(id)
{
	new title[64];
	formatex(title, 63, "\r[BHOP] \d- \wMain Menu");
	new menu = menu_create(title, "MenuHandler");
	
	menu_additem( menu, "\wStart", "1");
	menu_additem( menu, "\wInvis \rMenu", "2");
	menu_additem( menu, "\wHud \rMenu", "3");
	menu_additem( menu, "\yMedals \rMenu", "4");
	menu_additem( menu, "\wCategories \rMenu", "5");
	menu_additem( menu, "\wTop \rMenu", "6");
	menu_additem( menu, "\yShop", "7");
	menu_additem( menu, "\wBot \rMenu", "8");
	menu_additem( menu, "", "");
	menu_additem( menu, "\wExit", "9");

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
		case 0: spawn_player(id);
		case 1: invis_menu(id);
		case 2: open_hud_menu(id);
		case 3: open_medals_menu(id);
		case 4: open_cat_menu(id);
		case 5: open_top_menu(id);
		case 6: open_shop_menu(id);
		case 7: open_bot_menu(id);
		case 8:
		{
			menu_destroy(menu);
			return PLUGIN_HANDLED;
		}
		case 9:
		{
			menu_destroy(menu);
			return PLUGIN_HANDLED;
		}
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public save_menu(id)
{
	new title[128];
	formatex(title, charsmax(title), "\r[FWO] \d- \wStartpoint Menu");
	new menu = menu_create(title, "SaveMenuHandler");

	formatex(title, charsmax(title), "\wSave Startpoint \d- %s", get_bool_save_point(id) ? "\y[Saved]" : "\r[Not Saved]");
	menu_additem(menu, title, "1")

	formatex(title, charsmax(title), "\wDelete Startpoint");
	menu_additem(menu, title, "2")

	formatex(title, charsmax(title), "\wStart");
	menu_additem(menu, title, "3")

	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL)
	menu_display(id, menu, 0);
}

public SaveMenuHandler(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
 
	switch(item)
	{
		case 0:
		{
			get_user_save_point(id);
			save_menu(id);
		}
		case 1:
		{
			reset_save_player(id);
			save_menu(id);
		}
		case 2:
		{
			spawn_player(id);
			save_menu(id);
		}
	}
	return PLUGIN_HANDLED;
}
