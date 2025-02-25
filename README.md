# Main Bhop / Speedrun Plugin

This is a plugin for Counter-Strike 1.6 servers that adds **Bunny Hop (Bhop)** and **Speedrun** functionalities, along with other utilities for players. The plugin was developed by **MrShark45** and provides commands to save positions, reset spawns, give weapons, and more.

## Features

- **Save Starting Position**: Players can save a starting position to respawn there later.
- **Reset Spawn**: Reset the saved position and respawn at the initial point.
- **Save Menu**: An interactive menu to save, delete, or use saved positions.
- **Give Weapons**: Command to give specific weapons to players (USP and knife).
- **Spectator Mode**: Switch between spectator mode and the CT team.
- **Block Radio and Spray**: Blocks the use of radio commands and sprays.
- **Native Support**: Natives for integration with other plugins, such as **mainmenu**.

## Available Commands

- **/start** or **start**: Respawn the player at the saved position. If no position is saved, the player respawns at the map's initial point.
- **/reset** or **reset**: Reset the saved position and respawn the player at the initial point.
- **/save** or **/savemenu** or **/sm**: Open the save position menu.
- **savepos**: Save the player's current position directly through the console, without needing to interact with the menu.
- **/respawn**: Respawn the player at the map's initial point, **ignoring any saved position**.
- **/spec** or **/back**: Switch between spectator mode and the CT team.
- **/usp**: Give the player a USP and a knife.

## How to Use

1. **Save a Position**:
   - Use the `/save` or `savepos` command to save your current position.
   - The `savepos` command can be used directly in the console, without needing to interact with the menu.
   - The save menu can also be accessed with `/savemenu` or `/sm`.

2. **Respawn at the Saved Position**:
   - Use the `/start` command to respawn at the saved position.
   - If no position is saved, the player respawns at the map's initial point.

3. **Reset the Saved Position**:
   - Use the `/reset` command to reset the saved position and respawn at the initial point.

4. **Respawn at the Initial Point**:
   - Use the `/respawn` command to respawn at the map's initial point, **ignoring any saved position**.

5. **Save Menu**:
   - The menu allows you to save, delete, or use the saved position.

6. **Give Weapons**:
   - Use the `/usp` command to receive a USP and a knife.

7. **Switch to Spectator Mode**:
   - Use the `/spec` command to switch between spectator mode and the CT team.
   - You can also use `/ct` to switch between spectator mode and the CT team.

## Integration with Mainmenu

The **Main** plugin was developed to integrate with another plugin called **mainmenu**, which is in the same repository. The **mainmenu.sma** allows players to interact with other server plugins in a centralized way.

### Available Natives

The **main.sma** exposes the following natives for integration with **mainmenu.sma**:

- **native_spawn_player(id)**: Respawn the player at the saved position.
- **native_save_player(id)**: Reset the player's saved position.
- **native_open_save_menu(id)**: Open the save menu for the player.

These natives are used by **mainmenu** to provide additional functionalities to players.

## Help Plugin (Commands and Assistance)

In the same repository, there is a plugin called **help.sma**, which displays an HTML page (MOTD) with the list of commands available on the server. This plugin can be accessed directly through **mainmenu** (case 8) or via the following commands:

- **/comandos**: Opens the help page with the list of commands.
- **/help**: Also opens the help page.

## Credits
- **MrShark45**
- **ftl~ツ**