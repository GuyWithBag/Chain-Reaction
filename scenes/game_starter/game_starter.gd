extends Node
class_name GameStarter

@export var managers: LocalManagers

func start(start_data: GameStartData) -> void: 
	UIManager.set_gui_active(UIManager.player_screen, true)
	managers.players.start(start_data)
	managers.gameplay.start(start_data)
	
