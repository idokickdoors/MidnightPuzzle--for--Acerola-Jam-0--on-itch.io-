extends Node3D

@onready var spot_light = $LightEmitter/SpotLight3D
@onready var light_emitter = $LightEmitter

@export var active_material: BaseMaterial3D
@export var inactive_material: BaseMaterial3D

func activate():
	spot_light.visible = true
	light_emitter.material_override = active_material

func deactivate():
	spot_light.visible = false
	light_emitter.material_override = inactive_material
