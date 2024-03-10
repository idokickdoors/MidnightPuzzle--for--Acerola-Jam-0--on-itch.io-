extends StaticBody3D

const BUTTON_ACTIVE = preload("res://Assets/Materials/Button_Active.tres")
const BUTTON_INACTIVE = preload("res://Assets/Materials/Button_Inactive.tres")
@onready var light_disc = $LightDisc
@onready var light_emitter = $LightEmitter

signal activated
signal deactivated
var active := false

var heat = 0
var hit_heat = 2
func hit_with_light():
	active = true
	heat = hit_heat
	light_disc.material_override = BUTTON_ACTIVE
	light_emitter.light_color = BUTTON_ACTIVE.emission

var was_active := false
func _physics_process(_delta):
	if heat > 0:
		heat -= 1
	else:
		active = false
		light_disc.material_override = BUTTON_INACTIVE
		light_emitter.light_color = BUTTON_INACTIVE.emission
	
	if not active == was_active:
		if active:
			activated.emit()
		else:
			deactivated.emit()
	was_active = active
