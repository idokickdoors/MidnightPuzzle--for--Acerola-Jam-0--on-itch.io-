extends Path3D

@export var speed: float = 1.0
@onready var platform_mover = $PlatformMover
var direction = -1

func _physics_process(delta):
	platform_mover.progress += speed * direction * delta

func activate():
	direction = 1

func deactivate():
	direction = -1
