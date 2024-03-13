extends Node

@onready var camera: Camera3D = $".."
@onready var camera_ray: RayCast3D = $"../CameraRay"
const GRABBABLE_MATERIAL = preload("res://Assets/Materials/GrabbableMaterial.tres")
@onready var character = $"../.."
@onready var grip_slip_timer = $GripSlipTimer

var held_box: RigidBody3D
var held_box_path: NodePath
var hold_distance: float = 1.8
var max_hold_velo: float = 20.0
var grip_slip_distance: float = 2.0

func pickup_box(box: RigidBody3D):
	held_box = box
	held_box_path = get_tree().root.get_path_to(held_box)
	held_box.gravity_scale = 0
	held_box.global_basis = Basis.looking_at(camera.global_basis * Vector3.FORWARD * Vector3(1, 0, 1))
	held_box.angular_velocity = Vector3.ZERO
	character.add_collision_exception_with(held_box)
	set_crosshair(true)
	held_box.set_meta("Held", true)

func drop_box():
	for child in held_box.get_children(true):
		if child is MeshInstance3D:
			child.material_overlay = null
	held_box.gravity_scale = 1
	character.remove_collision_exception_with(held_box)
	held_box.remove_meta("Held")
	held_box = null
	set_crosshair(false)
	
	if not grip_slip_timer.is_stopped():
		grip_slip_timer.stop()

var prev_found: RigidBody3D
func find_box() -> RigidBody3D:
	if camera_ray.get_collider():
		if not camera_ray.get_collider() is RigidBody3D:
			return
		var box: RigidBody3D = camera_ray.get_collider()
		if box.is_in_group("grabbable"):
			set_child_material_overlay(box, GRABBABLE_MATERIAL)
			return box
	return null

func set_child_material_overlay(node, material):
	if not node:
		return
	
	for child in node.get_children(true):
		if child is MeshInstance3D:
			child.material_overlay = material

func grip_slip():
	held_box.linear_velocity = Vector3.ZERO
	held_box.angular_velocity = Vector3.ZERO
	drop_box()

func _physics_process(delta):
	if held_box and (not get_tree().root.has_node(held_box_path) or held_box.is_queued_for_deletion()):
		held_box = null
		prev_found = null
		set_crosshair(false)
		return
	
	if prev_found:
		set_child_material_overlay(prev_found, null)
	
	if held_box:
		if Input.is_action_just_pressed("pickup"):
			drop_box()
	else:
		var box := find_box()
		prev_found = box
		if box and Input.is_action_just_pressed("pickup"):
			pickup_box(box)
			prev_found = null
	
	if held_box:
		var look_dir = camera.global_basis * Vector3.FORWARD
		look_dir = (look_dir * Vector3(1, 0, 1)).normalized() + Vector3(0, look_dir.y, 0)
		var hold_position = camera.global_position + look_dir * hold_distance
		if held_box.global_position.distance_to(hold_position) > grip_slip_distance:
			if grip_slip_timer.is_stopped():
				grip_slip_timer.start()
		else:
			if not grip_slip_timer.is_stopped():
				grip_slip_timer.stop()
		var velo_vec = hold_position - held_box.global_position
		held_box.linear_velocity = velo_vec.normalized() * (pow(velo_vec.length() * 2, 3) / 2)
		held_box.linear_velocity = held_box.linear_velocity.normalized() * min(held_box.linear_velocity.length(), max_hold_velo)
		held_box.linear_velocity += character.velocity
		
		held_box.angular_velocity = held_box.angular_velocity.move_toward(Vector3.ZERO, delta)

@onready var neutral_crosshair = $"../NeutralCrosshair"
@onready var holding_crosshair = $"../HoldingCrosshair"
func set_crosshair(holding: bool):
	neutral_crosshair.visible = not holding
	holding_crosshair.visible = holding
