extends ReferenceRect

@onready var pause_menu: GUI = $"../../../"


func _on_resume_pressed() -> void:
	UIManager.set_gui_active(UIManager.pause_menu, false)



func _on_exit_game_pressed() -> void:
	GameManager.quit_to_main_menu_prompt(
		func(): 
			UIManager.remove_gui(pause_menu)
	)


func _on_exit_to_desktop_pressed() -> void:
	GameManager.quit_game_prompt(
		func(): 
			UIManager.remove_gui(pause_menu)
	)


func _on_restart_game_pressed():
	GameManager.retry_game_prompt(
		func(): 
			UIManager.remove_gui(pause_menu)
	)
