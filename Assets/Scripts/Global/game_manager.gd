extends Node

const CHARACTER = preload("res://Assets/Scenes/Gameplay/Character.tscn")

var level_node
var level_res_path
var level_transform
var spawn_transform

func set_current_level(node: Node3D, spawn_location: Transform3D):
	level_node = node
	level_res_path = node.scene_file_path
	level_transform = node.global_transform
	spawn_transform = spawn_location

func reload_from_checkpoint():
	var parent = level_node.get_parent()
	
	get_tree().get_first_node_in_group("Character").queue_free()
	
	level_node.queue_free()
	var level = load(level_res_path).instantiate()
	level.global_transform = level_transform
	parent.add_child(level)
	level_node = level
	
	var character = CHARACTER.instantiate()
	parent.add_child(character)
	character.global_transform = spawn_transform
	
	get_tree().paused = false
