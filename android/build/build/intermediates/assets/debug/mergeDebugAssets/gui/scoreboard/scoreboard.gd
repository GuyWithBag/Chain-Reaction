extends GUI
class_name Scoreboard


func set_active(value: bool) -> void: 
	super.set_active(value)
	GameManager.pause_game(value)


func _on_back_pressed() -> void:
	UIManager.set_gui_active(self, false)
