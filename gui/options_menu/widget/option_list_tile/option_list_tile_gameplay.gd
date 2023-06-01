extends OptionListTile

var player_color_picker: PackedScene = load("res://gui/options_menu/widget/player_color_picker/player_color_picker.tscn") 

@onready var players: VBoxContainer = get_node("%PlayersList")


func _on_add_more_players_pressed() -> void: 
	var button: PlayerColorPicker = player_color_picker.instantiate()
	players.add_child(button) 
	button.player_number = players.get_child_count() 


func _on_spin_box_value_changed(value: float) -> void:
	pass # Replace with function body.
