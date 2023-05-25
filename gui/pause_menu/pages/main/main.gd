extends ReferenceRect


func _on_resume_pressed() -> void:
	UIManager.set_gui_active(UIManager.pause_menu, false)


func _on_exit_game_pressed() -> void:
	pass # Replace with function body.


func _on_exit_to_desktop_pressed() -> void:
	GameManager.quit_game()
