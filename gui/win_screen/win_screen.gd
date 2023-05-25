extends GUI

@onready var team_label: Label = get_node("CenterContainer/VBoxContainer/WinningTeam")
@onready var victory_label: Label = get_node("CenterContainer/VBoxContainer/Victory")

var team_labeL_text: String = "Team: %s"


func _ready() -> void: 
	team_label.text = team_labeL_text % GameplayManager.winning_atom_team.team_number
	GameManager.pause_game(true)


func _on_play_again_pressed() -> void:
	GameManager.retry_game()
	close()


func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")
	close()


func close() -> void: 
	GameManager.pause_game(false)
	UIManager.remove_gui(self)
	
	
