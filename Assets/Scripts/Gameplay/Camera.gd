extends Camera3D

var camera_angles := Vector3.ZERO
var y_limit: float = deg_to_rad(89.9)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	var mouse_sens: Vector2 = GameSettings.mouse_sensitivity
	if event is InputEventMouseMotion:
		camera_angles += Vector3(
			-event.relative.y * mouse_sens.y,
			-event.relative.x * mouse_sens.x,
			0
		)

func _process(delta):
	# Gamepad Input
	var input_dir = Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up").limit_length()
	input_dir *= input_dir.length()
	var gamepad_sens = GameSettings.gamepad_sensitivity
	camera_angles += Vector3(
		input_dir.y * gamepad_sens.y,
		input_dir.x * gamepad_sens.x,
		0
	) * delta
	
	# Clamp vertical
	camera_angles.x = clamp(camera_angles.x, -y_limit, y_limit)
	
	# Apply
	basis = Basis.from_euler(camera_angles)
