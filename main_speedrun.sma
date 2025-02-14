#include <amxmodx>
#include <fun>
#include <cstrike>
#include <fakemeta_util>
#include <amxmisc>
#include <hamsandwich>
#include <engine>
#include <cromchat2>
#include <timer>
#include <hamsandwich>
#include <mainmenu>

#define PLUGIN "Main bhop"
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#define MAX_PLAYERS 32

#define SPRAY 201

const m_bHasReceivedDefItems = 480;
const m_iTeam = 114;
const WEAPON_SUIT_BIT = 1<<WEAPON_SUIT;

new const Float:VEC_DUCK_HULL_MIN[3] = { -16.0, -16.0, -18.0 };
new const Float:VEC_DUCK_HULL_MAX[3] = { 16.0, 16.0, 18.0 };

new iHideWeapon;

new start_position[33][3];
new Float:start_angles[33][3];
new Float:start_velocity[33][3];
new bool:used_save[33];
new bool:isStartSaved[33];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);

	set_msg_block(get_user_msgid("ClCorpse"), BLOCK_SET);

	RegisterHam(Ham_Spawn, "player", "PreSpawn", 0);
	RegisterHam(Ham_Spawn, "player", "Spawn", 1);

	RegisterHam( Ham_Killed, "player", "Killed", 0 );

	register_message(get_user_msgid("StatusIcon"), "MessageStatusIcon");

	register_clcmd( "say /start", "Start" );
	register_clcmd( "say /reset", "ResetStart");
	register_clcmd( "say /save", "open_savemenuCMD" );

	register_clcmd( "say /respawn", "Respawn");

	register_clcmd( "say /spec", "Spec");
	register_clcmd( "say /back", "Spec");
	register_clcmd( "say /ct", "Spec");
	register_clcmd( "say /usp", "GiveWeapons");

	register_concmd("radio1", "hook_radio");
	register_concmd("radio2", "hook_radio");
	register_concmd("radio3", "hook_radio");

	iHideWeapon = get_user_msgid("HideWeapon");

	//Chat prefix
	CC_SetPrefix("&x04[FWO]");
}

public plugin_cfg(){
	register_dictionary("main.txt");
}

public plugin_natives(){
	register_library("main");

	register_native("spawn_player", "native_spawn_player");
	register_native("reset_save_player", "native_save_player");
	register_native("get_bool_save_point", "native_bool_save_point");
	register_native("get_user_save_point", "native_save_point");
}

public native_spawn_player(numParams){
	new id = get_param(1);
	Start(id);
}

public native_save_player(numParams){
	new id = get_param(1);
	ResetStart(id);
}

public native_save_point(numParams){
	new id = get_param(1);
	SaveStart(id);
}

public native_bool_save_point(numParams){
	new id = get_param(1);
	return isStartSaved[id];
}

public client_putinserver(id){
	start_position[id][0] = 0;
	used_save[id] = false;
}

public client_disconnected(id){
	start_position[id][0] = 0;
	used_save[id] = false;
}

public timer_player_category_changed(id){
	start_position[id][0] = 0;
	used_save[id] = false;
}

public PreSpawn(id){
	if( pev_valid(id) == 2 && (1 <= get_pdata_int(id, m_iTeam) <= 2) )
	{
		set_pdata_bool(id, m_bHasReceivedDefItems, true);
		new weapons = pev(id, pev_weapons);
		if( ~weapons & WEAPON_SUIT_BIT )
		{
			set_pev(id, pev_weapons, weapons | WEAPON_SUIT_BIT);
		}
		return HAM_HANDLED;
	}
	return HAM_IGNORED;
}

public Spawn(id){
	if(is_user_bot(id))
		return PLUGIN_CONTINUE;

	//hide user hud elements
	message_begin(MSG_ONE_UNRELIABLE, iHideWeapon, _, id);
	write_byte(2 | 8 | 16 | 32);
	message_end();

	FixCrosshair(id);

	set_task(0.2,"GiveWeapons",id);
	return PLUGIN_CONTINUE;
}

public Killed(id){
	set_pev( id, pev_effects, pev( id, pev_effects ) | EF_NODRAW );
	entity_set_int(id, EV_INT_deadflag, DEAD_DISCARDBODY);

	if(cs_get_user_team(id) == CS_TEAM_CT){
		ExecuteHamB ( Ham_CS_RoundRespawn , id );
		return HAM_SUPERCEDE;
	}
	engclient_cmd(id, "follow", "Record Bot");

	return HAM_SUPERCEDE;
}


public Start(id){
	if (cs_get_user_team(id) == CS_TEAM_CT){
		ExecuteHamB ( Ham_CS_RoundRespawn , id );
		if(start_position[id][0]){
			used_save[id] = true;
			// make user duck on first frame to avoid getting stuck in the ground
			set_pev( id, pev_flags, pev( id, pev_flags ) | FL_DUCKING );
			engfunc( EngFunc_SetSize, id, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX )
			set_user_origin(id, start_position[id]);
			SetUserAgl(id, start_angles[id]);
			set_user_velocity(id, start_velocity[id]);
		}
	}
}

public Respawn(id){
	if (cs_get_user_team(id) == CS_TEAM_CT){
		ExecuteHamB ( Ham_CS_RoundRespawn , id );
		used_save[id] = false;
	}
}

public SaveStart(id){
	if (!is_user_alive(id)){
		CC_SendMessage(id, "%L", id, "MSG_NOT_ALIVE");
		return PLUGIN_HANDLED;
	}
	if(used_save[id]){
		CC_SendMessage(id, "%L", id, "MSG_USED");
		return PLUGIN_HANDLED;
	}

	if(get_user_rule_speedrun(id)){
		if(!entity_intersects(id, get_entity_start())){
			CC_SendMessage(id, "%L", id, "MSG_OUTSIDE_ZONE");
			return PLUGIN_HANDLED;
		}

		if(get_speed(id)){
			CC_SendMessage(id, "%L", id, "MSG_SPEED");
			return PLUGIN_HANDLED;
		}
	}
	
	get_user_origin(id, start_position[id], 0);
	entity_get_vector(id, EV_VEC_angles, start_angles[id]);
	start_angles[id][0] *= -3.0;
	get_user_velocity(id, start_velocity[id]);
	isStartSaved[id] = true;
	return PLUGIN_HANDLED;
}

public open_savemenuCMD(id){
	open_savemenu(id);
}

public ResetStart(id){
	if (!is_user_alive(id)){
		CC_SendMessage(id, "%L",id, "MSG_NOT_ALIVE");
		return PLUGIN_HANDLED;
	}
	start_position[id][0] = 0;
	used_save[id] = false;
	isStartSaved[id] = false;
	ExecuteHamB ( Ham_CS_RoundRespawn , id );
	return PLUGIN_HANDLED;
}

public szSaveStatus(id){
	isStartSaved[id] = (isStartSaved[id] != false) ? false : true;
	return PLUGIN_HANDLED;
}

public GiveWeapons(id){
	if(!is_user_connected(id) || !is_user_alive(id))
		return PLUGIN_CONTINUE;
	fm_strip_user_gun( id, CSW_SCOUT );
	give_item(id,"weapon_usp");
	give_item(id,"ammo_45acp");
	give_item(id,"ammo_45acp");
	give_item(id, "weapon_knife");
	return PLUGIN_CONTINUE;
}

public Spec(id)
{
	if (cs_get_user_team(id) == CS_TEAM_SPECTATOR){
		cs_set_user_team(id, CS_TEAM_CT, CS_DONTCHANGE);
		set_task(0.1, "Respawn", id);
	}
	else{
		cs_set_user_team(id, CS_TEAM_SPECTATOR, CS_DONTCHANGE);
		user_silentkill(id);
	}
	return;
}

public MessageStatusIcon(msg, dest, id) {
	new icon[8]; get_msg_arg_string(2, icon, 7);

	if(equal(icon, "buyzone") && get_msg_arg_int(1)) {
		set_pdata_int(id, 235, get_pdata_int(id, 235) & ~(1<<0));
		return 1;
	}
	return 0;
} 

public client_impulse(id, impulse)
{
	if(impulse == SPRAY)
	{
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
}

public hook_radio() {
	return PLUGIN_HANDLED;
}

stock FixCrosshair( id ) 
{
	static iCrosshair;
	if ( !iCrosshair )
	{
		iCrosshair = get_user_msgid( "Crosshair" );
	}
	
	message_begin( MSG_ONE_UNRELIABLE, iCrosshair, _, id ); 
	write_byte( 0 ); 
	message_end( ); 
} 
stock get_random_player(){
	for(new i = 1; i<33; i++)
		if(is_user_connected(i) && is_user_alive(i))
			return i;
	return 0;
}

stock SetUserAgl(id,Float:agl[3]){
	entity_set_vector(id,EV_VEC_angles,agl);
	//entity_set_int(id,EV_INT_fixangle,1);
}