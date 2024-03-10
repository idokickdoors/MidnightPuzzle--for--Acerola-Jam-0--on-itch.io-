extends Button

@onready var hold_timer = $HoldTimer
@onready var progress_bar = $ProgressBar


func _on_button_down():
	hold_timer.start(0)

func _on_button_up():
	hold_timer.stop()

func _process(_delta):
	progress_bar.value = hold_timer.time_left / hold_timer.wait_time


func on_reload_pressed():
	GameManager.reload_from_checkpoint()
