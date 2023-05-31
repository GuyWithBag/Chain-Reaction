extends GUI

@onready var team_label: Label = %WinningPlayer
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 

var team_labeL_text: String = "Player: %s"


# called from GameplayManager
func _ready() -> void: 
	team_label.text = team_labeL_text % GameplayManager.winning_atom_player.team_number
	UIManager.set_gui_active(self, false)
	BackgroundAudioManager.play_temporary_sound(AudioEffectsLoader.get_sfx("Victory"))
	animation_player.play("come_up")
	GameManager.pause_game(true)


func _on_play_again_pressed() -> void:
	GameManager.retry_game_prompt(close)


func _on_return_to_menu_pressed() -> void:
	GameManager.quit_to_main_menu_prompt(close)


func close() -> void: 
	UIManager.remove_gui(self)


