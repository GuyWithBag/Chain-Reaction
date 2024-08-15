#@tool 
extends HBoxContainer
class_name PlayerColorPicker

@export var player_number: int = 1: 
	set(value): 
		player_number = value
		if Engine.is_editor_hint(): 
			player_name = get_node("PlayerName") 
		if player_name: 
			player_name.text = player_name_text % str(player_number)

var player_name_text: String = "Player %s" 

@onready var player_name: Label = get_node("PlayerName") 
@onready var color_picker_button: ColorPickerButton = get_node("ColorPickerButton") 
@onready var reset_color: TextureButton = get_node("ResetColor") 


func _ready() -> void: 
	player_number = player_number
	set_player_default_color()


func _on_color_picker_button_color_changed(color: Color) -> void: 
	if Engine.is_editor_hint(): 
		color_picker_button = get_node("ColorPickerButton") 
	set_player_color(color)
	if PlayersManager.default_player_colors.has(player_number): 
		if color != PlayersManager.default_player_colors[player_number]: 
			reset_color.show()
		else: 
			reset_color.hide() 


func _on_reset_color_pressed() -> void:
	set_player_default_color()
	reset_color.hide() 


func set_player_color(color: Color) -> void: 
	PlayersManager.player_colors[str(player_number)] = color 
	
	
# Sets the player color to the default color
func set_player_default_color() -> void: 
	set_player_color(PlayersManager.default_player_colors[str(player_number)])
	color_picker_button.color = PlayersManager.default_player_colors[str(player_number)]
	
