extends Node
class_name ButtonSFXComponent


@export var sound_effect: AudioStream
@export var is_autoload_effect: bool = false

@export var audio_stream_player: AudioStreamPlayer


func _ready() -> void: 
	owner.pressed.connect(_on_pressed)


func _on_pressed() -> void: 
	if is_autoload_effect: 
		BackgroundAudioManager.play_temporary_sound(sound_effect) 
		return
	audio_stream_player.stream = sound_effect 
	audio_stream_player.play()
	
	
	
