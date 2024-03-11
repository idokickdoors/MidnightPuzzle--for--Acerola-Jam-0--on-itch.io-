extends Area3D

@export var water_force: float = 2.5
@export var water_accel: float = 40.0

func _physics_process(delta):
	var force = -global_basis.z * water_force
	force += gravity_direction * gravity
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			body.linear_velocity = body.linear_velocity.move_toward(force, water_accel * delta)
