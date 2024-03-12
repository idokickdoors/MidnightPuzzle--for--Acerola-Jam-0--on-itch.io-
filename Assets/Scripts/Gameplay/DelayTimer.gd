extends Timer

@onready var ticking_sound = $Sounds/TickingSound
@onready var ended_sound = $Sounds/EndedSound

@export var use_sound: bool = true

func reset_timer():
	stop()
	if use_sound:
		ticking_sound.stop()

func start_timer():
	start()
	if use_sound:
		ticking_sound.play()

func _on_timeout():
	if use_sound:
		ticking_sound.stop()
		ended_sound.play()
