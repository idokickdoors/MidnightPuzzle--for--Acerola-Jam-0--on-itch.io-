extends CharacterBody3D

@onready var camera = $Camera
@onready var footsteps = $Footsteps

var move_speed: float = 5.0
var move_accel: float = 62.0
var jump_force: float = 7.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_force
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_foward", "move_backward").limit_length()
	input_dir *= input_dir.length()
	var move_vec = Vector3(input_dir.x, 0, input_dir.y)
	move_vec = Basis.from_euler(Vector3(0, camera.camera_angles.y, 0)) * move_vec
	move_vec *= move_speed
	
	var ground_velo = (velocity * Vector3(1, 0, 1)).move_toward(move_vec, move_accel * delta)
	velocity.x = ground_velo.x
	velocity.z = ground_velo.z
	move_and_slide()
	
	if velocity.length() > 1 and is_on_floor():
		if not footsteps.playing:
			footsteps.play()
