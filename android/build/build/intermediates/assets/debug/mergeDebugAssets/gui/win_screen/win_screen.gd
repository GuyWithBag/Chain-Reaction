extends GUI

@onready var player_label: Label = %WinningPlayer
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 

var player_label_text: String = "Player: %s"


# called from GameplayManager
func _ready() -> void: 
	player_label.text = player_label_text % GameplayManager.winning_atom_player.team_number
	player_label.add_theme_color_override("font_color", AtomPlayerTurnsManager.current_atom_player_in_turn.team_color)
	UIManager.set_gui_active(self, false)
	BackgroundAudioManager.play_temporary_sound(AudioEffectsLoader.get_sfx("Victory"))
	animation_player.play("come_up")


func _on_play_again_pressed() -> void:
	GameManager.retry_game_prompt(close)


func _on_return_to_menu_pressed() -> void:
	GameManager.quit_to_main_menu_prompt(close)


func close() -> void: 
	UIManager.remove_gui(self)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GameManager.pause_game(true)
