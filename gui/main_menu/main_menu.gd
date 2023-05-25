extends MenuGUI

@onready var player_amount_selector: Control = %PlayerAmount

var player_amount: int: 
	get: 
		return player_amount_selector.player_amount


func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _on_vs_players_pressed() -> void: 
	var game_start_data: GameStartData = GameStartData.new(
		MapsLoader.get_map("Game World 1"), 
		GameMode.new(GameMode.VS_PLAYERS), 
		player_amount
	)
	GameManager.game_start_data = game_start_data


func _on_vs_ai_pressed() -> void:
	var game_start_data: GameStartData = GameStartData.new(
		MapsLoader.get_map("Game World 1"), 
		GameMode.new(GameMode.VS_PLAYERS), 
		player_amount
	)
	GameManager.game_start_data = game_start_data


func _on_start_game_pressed() -> void:
	GameManager.start_game()
	
	
