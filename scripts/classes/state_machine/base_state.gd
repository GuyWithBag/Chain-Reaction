class_name BaseState
extends Node

@export var animation_name: String
@export var sound_effect: AudioStreamPlayer2D

# Pass in a reference to the state_machine_owner's character body so that it can be used by the state
@onready var state_machine: StateMachine
@onready var state_machine_owner: Node2D


func init(_state_machine_owner: Node2D) -> void:
	state_machine = get_parent()
	state_machine_owner = _state_machine_owner


func enter() -> void:
#	state_machine_owner.animations.play(animation_name)
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> BaseState:
	return null

func process(_delta: float) -> BaseState:
	return null

func physics_process(_delta: float) -> BaseState:
	return null


func set_owner_process_unhandled_input(value: bool) -> void:
	if !state_machine_owner.has_node("InputEventHandler"):
		return
	state_machine_owner.input_event_handler.disabled = value

