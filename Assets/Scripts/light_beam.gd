extends Node3D

@onready var raycast = $RayCast3D
@onready var visual = $Visual
@export var length: float = 100.0;

func _ready():
	raycast.target_position.z = length

func set_beam_length(size: float):
	visual.scale.z = size
	visual.position.z = size / 2

func _physics_process(_delta):
	if raycast.is_colliding():
		var hit_point = raycast.get_collision_point()
		var dist = position.distance_to(hit_point)
		set_beam_length(dist)
		
		var hit_node: Node3D = raycast.get_collider()
		if hit_node.has_method("hit_with_light"):
			hit_node.hit_with_light()
	else:
		set_beam_length(length)
