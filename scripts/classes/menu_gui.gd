extends CanvasLayer
class_name MenuGUI

func _ready() -> void: 
	GameManager.current_state = GameManager.State.MENU
	UIManager.set_gui_active(UIManager.player_screen, false)
	
	
func _notification(what: int) -> void: 
	if what == NOTIFICATION_PREDELETE: 
		BackgroundAudioManager.stop_music(BackgroundAudioManager.SoundTransition.FADE_OUT, 0.7) 
		pass

