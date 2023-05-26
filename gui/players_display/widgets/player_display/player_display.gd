extends Control
class_name PlayerDisplay

var atom_player: AtomPlayer 
var display_text: String = "Player %s atoms left: %s |"

@onready var display: Label = get_node("MarginContainer/Display") 


func format_text(format: Array[String]) -> void: 
	display.text = display_text % format
