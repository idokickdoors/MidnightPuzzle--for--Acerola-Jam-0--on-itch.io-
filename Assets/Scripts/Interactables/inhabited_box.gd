extends RigidBody3D

@onready var animation_player = $AnimationPlayer

@export var moving: bool = false
@export var move_force: float = 2.2

var active = false
signal activated
@onready var activation_area = $ActivationArea
func _on_activation(body):
	if active:
		return
	if not body is CharacterBody3D:
		return
	active = true
	activated.emit()
	animation_player.animation_set_next("Activate", "BoxMove")
	animation_player.play("Activate")

func _physics_process(_delta):
	if not active:
		return
	
	if has_meta("Held"):
		return
	
	if moving:
		var down_velo = linear_velocity.y
		linear_velocity = basis.z * move_force
		linear_velocity.y += down_velo
		angular_velocity.y = 0.0
