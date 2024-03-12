extends Node3D


@export var MOVABLE_BOX = preload("res://Assets/Scenes/Interactables/movable_box.tscn")

var tracked_box

func _ready():
	spawn_box()

func spawn_box():
	var box = MOVABLE_BOX.instantiate()
	add_sibling.call_deferred(box)
	box.transform = transform
	tracked_box = box
	box.tree_exiting.connect(spawn_box)

func kill_box():
	if tracked_box:
		tracked_box.queue_free()
