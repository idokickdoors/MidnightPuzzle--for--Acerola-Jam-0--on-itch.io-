extends Area3D

@onready var button = $Button
@onready var button_mesh = $Button/ButtonMesh
@onready var button_light = $Button/ButtonMesh/ButtonLight

const UP_POS := Vector3(0, 0.1, 0)
const DOWN_POS := Vector3(0, 0.02, 0)
const TWEEN_TIME: float = 0.6

const BUTTON_ACTIVE = preload("res://Assets/Materials/Button_Active.tres")
const BUTTON_INACTIVE = preload("res://Assets/Materials/Button_Inactive.tres")

@onready var button_activate_sfx = $ButtonActivateSFX
@onready var button_deactivate_sfx = $ButtonDeactivateSFX

signal activated
signal deactivated

var tween: Tween
func tween_up():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(button, "position", UP_POS, TWEEN_TIME)
	
	button_mesh.material_override = BUTTON_INACTIVE
	button_light.light_color = BUTTON_INACTIVE.emission
	
	button_deactivate_sfx.play()
	deactivated.emit()

func tween_down():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(button, "position", DOWN_POS, TWEEN_TIME)
	
	button_mesh.material_override = BUTTON_ACTIVE
	button_light.light_color = BUTTON_ACTIVE.emission
	
	button_activate_sfx.play()
	activated.emit()

func scan_for_boxes() -> bool:
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			if body.is_queued_for_deletion():
				continue
			return true
	return false

var active := false
func update_button():
	var active_now = scan_for_boxes()
	if active == active_now:
		return
	active = active_now
	
	if active:
		tween_down()
	else:
		tween_up()

func box_entered(_node: Node3D):
	update_button()

func box_exited(_node: Node3D):
	update_button()
