extends CanvasLayer
class_name LoadingScreen

signal ready_to_load

var in_transition_animation: String
var out_transition_animation: String

@onready var transition_player: AnimationPlayer = $TransitionPlayer


func _init() -> void: 
	visible = false


func init(_in_transition_animation: String, _out_transition_animation: String) -> void: 
	visible = true
	in_transition_animation = _in_transition_animation
	out_transition_animation = _out_transition_animation
	transition_player.animation_finished.connect(
		func(_x): 
			ready_to_load.emit() 
	, CONNECT_ONE_SHOT
	)
	transition_player.play(in_transition_animation)


func end_load() -> void: 
	transition_player.animation_finished.connect(
		func(_x): 
			queue_free() 
	, CONNECT_ONE_SHOT
	)
	transition_player.play(out_transition_animation)


