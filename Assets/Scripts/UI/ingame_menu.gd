extends Control

@onready var master_volume_slider = $MasterVolumeBox/Slider
@onready var mouse_sens_y_slider = $MouseSensYBox/Slider
@onready var mouse_sens_x_slider = $MouseSensXBox/Slider
@onready var gamepad_sens_y_slider = $GamepadSensYBox/Slider
@onready var gamepad_sens_x_slider = $GamepadSensXBox/Slider

@onready var master_bus = AudioServer.get_bus_index("Master")

var mouse_sens_mult = 100

func _ready():
	var volume = AudioServer.get_bus_volume_db(master_bus)
	volume = db_to_linear(volume)
	master_volume_slider.value = volume
	
	mouse_sens_y_slider.value = GameSettings.mouse_sensitivity.y * mouse_sens_mult
	mouse_sens_x_slider.value = GameSettings.mouse_sensitivity.x * mouse_sens_mult
	gamepad_sens_y_slider.value = GameSettings.gamepad_sensitivity.y
	gamepad_sens_x_slider.value = GameSettings.gamepad_sensitivity.x

func _unhandled_input(event):
	if event.is_action_pressed("toggle_ingame_menu"):
		_toggle_menu()

func _toggle_menu():
	visible = not visible
	get_tree().paused = visible
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func _on_mouse_sens_y_changed(value):
	GameSettings.mouse_sensitivity.y = value / mouse_sens_mult


func _on_mouse_sens_x_changed(value):
	GameSettings.mouse_sensitivity.x = value / mouse_sens_mult


func _on_gamepad_sens_y_changed(value):
	GameSettings.gamepad_sensitivity.y = value


func _on_gamepad_sens_x_changed(value):
	GameSettings.gamepad_sensitivity.x = value

var is_fullscreen: bool = true
@onready var fullscreen_tick_label = $FullscreenBox/TickLabel
func _on_fullscreen_pressed():
	is_fullscreen = not is_fullscreen
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_tick_label.text = "X"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		fullscreen_tick_label.text = ""
