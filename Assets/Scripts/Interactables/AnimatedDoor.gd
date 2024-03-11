extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var animation_name: String

@onready var door_close = $DoorClose
@onready var door_open = $DoorOpen

func _ready():
	for anim in animation_player.get_animation_list():
		if not anim == "RESET":
			animation_name = anim
			return

func activate():
	animation_player.play(animation_name, -1, 1, false)
	door_open.play()

func deactivate():
	animation_player.play(animation_name, -1, -1, true)
	door_close.play()
