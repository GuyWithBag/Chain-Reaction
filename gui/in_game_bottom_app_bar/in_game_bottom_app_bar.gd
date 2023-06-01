extends GUI
class_name InGameBottomAppBar

func _on_triangle_button_pressed() -> void:
	UIManager.set_gui_active(UIManager.scoreboard, true) 
