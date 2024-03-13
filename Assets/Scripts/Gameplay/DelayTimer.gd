extends Timer

@onready var ticking_sound = $Sounds/TickingSound
@onready var ended_sound = $Sounds/EndedSound

@export var use_sound: bool = true

@onready var sounds = $Sounds
func _ready():
	sounds.global_position = get_parent().global_position + sounds.global_position

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
