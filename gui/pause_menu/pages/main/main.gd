extends ReferenceRect


func _on_resume_pressed() -> void:
	UIManager.set_gui_active(UIManager.pause_menu, false)


func _on_exit_game_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")


func _on_exit_to_desktop_pressed() -> void:
	GameManager.quit_game()

