extends ReferenceRect

@onready var pause_menu: GUI = $"../../../"


func _on_resume_pressed() -> void:
	#close()
	pass


func _on_exit_game_pressed() -> void:
	GameManager.quit_to_main_menu_prompt(close)


func _on_exit_to_desktop_pressed() -> void:
	GameManager.quit_game_prompt(close)


func _on_restart_game_pressed():
	GameManager.retry_game_prompt(close)


func close() -> void: 
	#UIManager.set_gui_active(pause_menu, false)
	#GameManager.pause_game(false)
	pass
	
