/**
*  __    _     _         _    ____                  
* |  |  |_|___| |_ ___ _| |  |    \ ___ ___ ___ ___ 
* |  |__| |   | '_| -_| . |  |  |  | . | . |  _|_ -|
* |_____|_|_|_|_,_|___|___|  |____/|___|___|_| |___|
*
* A GameMaker asset to simplify moving a player between rooms
* Version: 0.1.2
*/


/**
* `global.__door_instance_info` schema
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
global.__door_instance_info = {};

/**
* `global.__door_link_info` schema
* Stores information that will be used to locate the matching door instance when entering a room
* Populated on create and searched on room start
*
*	{
*		_link_name: 100001,
*		_link_name: 100024,
*	}
*/
global.__door_link_info = {};
global.__door_link_target = undefined;


/**
* @function ld_declare_door(_link_name, _other_room)
* @descrioption Intended to be ran in instance creation code of your door object. This function will declare the calling instance as a "door". This door will automatically be "linked" to a door in the other_room with the same link_name
* @param	{String}	_link_name		Identifying name that will link two doors between rooms
* @param	{Asset}		_other_room		The room asset that the other door can be found in
* @return	{Undefined}
*/
function ld_declare_door(_link_name, _other_room) {
	global.__door_instance_info[$ id] = {
		other_room: _other_room,
		link_name: _link_name,
	};
	
	global.__door_link_info[$ _link_name] = id;
}


/**
* @function ld_trigger_door(_id)
* @description Called upon interaction with a door. Changes the room and sets which link to search for
* @param	{[Id.Instance]}		_id		Defaults to the calling instance's ID. This argument can be used if the function is called outside of a door instance's scope
* @return	{Undefined}
*/
function ld_trigger_door(_id = id) {
	// Get info about the door that was triggered, set target and change rooms
	var door_info = global.__door_instance_info[$ _id];
	global.__door_link_target = door_info.link_name;
	room_goto(door_info.other_room);
	
	// Reset to save memory
	global.__door_instance_info = {};
	global.__door_link_info = {};
}


/**
* @function ld_roomstart_find_door()
* @description Called upon room start to find the linked door's instance ID
* @return	{Id.Instance}		Instance ID of the linked door or noone
*/
function ld_roomstart_find_door() {
	if (global.__door_link_target != undefined) {
		// Get the target door's instance ID based on the target string
		var door_instance = global.__door_link_info[$ global.__door_link_target];
		
		// Reset the target and return found door instance
		global.__door_link_target = undefined;
		return door_instance ? door_instance : noone;
	}
	return noone;
}
