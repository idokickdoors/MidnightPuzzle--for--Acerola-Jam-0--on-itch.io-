extends AudioStreamPlayer3D

func body_entered(body):
	if body is RigidBody3D:
		play()
