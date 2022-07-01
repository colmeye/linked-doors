# Linked Doors

Linked Doors is a GameMaker asset to simplify moving a player between rooms. The goal of this asset is to remove hardcoded coordinates from room transitioning by relying on door instances with "links" between them. No assumptions are made about how the player will interact with the doors, meaning Linked Doors should work for all games.

# Installation

Download the latest release and import the .yymps file into GameMaker by dragging it into the IDE window or using the `tools` tab.

# Usage

Using Linked Doors is meant to be simple. There are only three functions that need to be used. **You'll also want a door object that the player can interact with.**

## ld_declare_door(link_name, other_room)

Intended to be ran in instance creation code of your door object. This function will declare the calling instance as a "door". This door will automatically be "linked" to a door in the `other_room` with the same `link_name`  

| Argument | Type | Description |
| --- | --- | --- |
| link_name | String | Identifying name that will link two doors between rooms. |
| other_room | GM Room Asset | The room asset that the other door can be found in. |

```javascript
/// Room: r_outside
/// Instance creation code of an object
ld_declare_door("house_abc_front", r_house_abc);
````

```javascript
/// Room: r_house_abc
/// Instance creation code of an object
ld_declare_door("house_abc_front", r_outside);
````

## ld_trigger_door([id])

Signals that the player has interacted with a certain door instance. The room will change to that door's `other_room` and the matching door will be searched for.

| Argument | Type | Description |
| --- | --- | --- |
| [id] | GM Instance ID | Optional. Defaults to the calling instance's ID. This argument can be used if the function is called outside of a door instance's scope. |

```javascript
/// Ex1: Door step event. Key press activated
if (distance_to_object(o_player) < 32 && keyboard_check_pressed(vk_enter)) {
    ld_trigger_door();
}
```

```javascript
/// Ex2: Door object collision with player event. Collision activated
ld_trigger_door();
```

## ld_roomstart_find_door()

Should be ran on room start. Returns the instance ID of the matching door in this room or `noone`. I would recommend using this function in a room start event of either: a persistant object that spawns the player, or the player itself to move it to the correct spot.

```javascript
/// Room start event of persistent object
var door = ld_roomstart_find_door();
if (door != noone) {
	o_player.x = door.x + lengthdir_x(16, door.image_angle);
	o_player.y = door.y + lengthdir_y(16, door.image_angle);
}
```
In the above example, if a linked door is found when entering a room, the player is placed 16px away from that door in the direction that it is facing.

# License
[MIT](https://choosealicense.com/licenses/mit/)
