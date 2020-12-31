# Godot Top Down Shooter Templete :gun:

A top down shooter templete made in Godot. This is the templete that I will eventually use to create a top down shooter game. For now I am building the back bone.
As you can see alot of what you need to create one is already in here. However, I would like to refactor the code to 
follow the [GDScript Style Guide](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_styleguide.html). In addition, I need to create
some new assets and get rid of the default Godot icon assets that are currently being used.

## Features :star:

* Player is able to swap between two weapons
* Two types of state machine with varying complexity (Player contains a node based state machine while monsters
implement a simple enum state machine).
* Monsters are able to path find around walls and attack the player when the player crosses their field of view, FOV.
* Two area of dectections around the player. If the monsters have a direct line of sight on the player and they shoot, the monsters 
will be alerted to the player. If a player is close enough to a monster but the monsters do not have a line of sight and the player shoots, 
the monsters will be alerted.


## How to Run :running:
This project currently runs on Godot 3.2.3.stable.

1. Open up the project in Godot
2. Under the *FileSystem*, open up *res://Scenes/World/World.tscn*.
3. Press the *F6* key.

Congrats! You are now playing the game!

## Controls :video_game:
W - Move Up

A - Move Left

S - Move Down

D - Move Right

R - Reload Gun

1 - Switch to Pistol

2 - Switch to Rifle

Shift - Run

CTL - Sneak

Use the mouse to aim around the screen. 
Press the left mouse button to Fire.
Press the right mouse button to melee


Press *F8* to exit the game.

## Credits :bookmark_tabs:
* Inital insperation for this was based off a small tutorial from [Miziziziz](https://www.youtube.com/watch?v=5vYI_mgERBU).
* Shooting was based off a tutorial by [Code with Tom](https://www.youtube.com/watch?v=cei9BZMzVLY&list=PLa6IX6n0yPfeSVVIIO48OF3XnRBc68X-K&index=8&t=120s).
* State machine implemented on the player was inspired by this project [nezvers](https://github.com/nezvers/Godot_2D_action_platformer).
