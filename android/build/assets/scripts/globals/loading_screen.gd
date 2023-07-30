extends Node

@onready var loading_scene = preload("res://gui/loading_scene/loading_screen.tscn")

var to_scene_path: String
var show_continue_button: bool = false

func load_scene(_to_scene_path: String, _show_continue_button: bool = false): 
	to_scene_path = _to_scene_path 
	show_continue_button = _show_continue_button 
	get_tree().change_scene_to_packed(loading_scene)
