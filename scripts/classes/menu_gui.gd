extends CanvasLayer
class_name MenuGUI

func _ready() -> void: 
	GameManager.current_state = GameManager.State.MENU
	UIManager.set_gui_active(UIManager.player_screen, false)
	
	
