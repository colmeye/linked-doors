/**
*  __    _     _         _    ____                  
* |  |  |_|___| |_ ___ _| |  |    \ ___ ___ ___ ___ 
* |  |__| |   | '_| -_| . |  |  |  | . | . |  _|_ -|
* |_____|_|_|_|_,_|___|___|  |____/|___|___|_| |___|
*
* A GameMaker asset to simplify moving a player between rooms
* Version: 0.1.0
*/


/**
* `global.door_instance_info` schema
* Stores information that will be used if the door is collided with
*
*	{
*		100001: {
*			other_room: r_example,
*			link_name: "link_name",
*		},
*		100024: {
*			other_room: r_example,
*			link_name: "link_name",
*		},
*	}
*/
global.door_instance_info = {};


/**
* `global.door_link_info` schema
* Stores information that will be used to locate the matching door instance when entering a room
* Populated on create and searched on room start
*
*	{
*		_link_name: 100001,
*		_link_name: 100024,
*	}
*/
global.door_link_info = {};
global.door_link_target = undefined;


/**
* Adds the calling instance to two global variables that will link it to another
* door in another room with the same `_link_name`
* @param	{string}	_link_name		Name for the link between two doors
* @param	{asset}		_other_room		Room to find the linked door in
* @return	{void}
*/
function ld_declare_door(_link_name, _other_room) {
	global.door_instance_info[$ id] = {
		other_room: _other_room,
		link_name: _link_name,
	};
	
	global.door_link_info[$ _link_name] = id;
}


/**
* Called upon collision with a door. Changes the room and sets which link to search for
* @return	{void}
*/
function ld_trigger_door(_id = id) {
	var door_info = global.door_instance_info[$ _id];
	
	global.door_link_target = door_info.link_name;
	room_goto(door_info.other_room);
}


/**
* Called upon room start to get access to the linked door, if there is one
* @return	{instance | noone}		Instance ID of the linked door
*/
function ld_roomstart_find_door() {
	if (global.door_link_target != undefined) {
		// Get the target door's instance ID based on the target string
		var door_instance = global.door_link_info[$ global.door_link_target];
		
		// Reset the target and return found door instance
		global.door_link_target = undefined;
		return door_instance ? door_instance : noone;
	}
	return noone;
}
