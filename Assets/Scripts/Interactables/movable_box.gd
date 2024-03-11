extends RigidBody3D

@onready var cardboard_sounds = $CardboardSounds

var prev_velocity := Vector3.ZERO
var velo_thresh := 40.0
func _process(_delta):
	if prev_velocity.dot(linear_velocity) > velo_thresh:
		if not cardboard_sounds.playing:
			if get_contact_count() > 0:
				cardboard_sounds.play()
	
	prev_velocity = linear_velocity
