extends Area3D

@onready var animation_player = $"AnimationPlayer"
@onready var exit_button = $CutsceneCamera/ExitButton

signal trigger

func _on_body_entered(body):
	if not body is CharacterBody3D:
		return
	
	get_tree().get_first_node_in_group("Character").queue_free()
	animation_player.play("FridgeOpen")

func _on_animation_finished(anim_name):
	if anim_name == "FridgeOpen":
		exit_button.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
