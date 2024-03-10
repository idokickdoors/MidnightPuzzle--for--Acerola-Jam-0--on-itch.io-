extends Area3D

func _activate_checkpoint():
	GameManager.set_current_level(get_parent(), global_transform)

func _on_body_entered(body):
	if body is CharacterBody3D:
		_activate_checkpoint()
