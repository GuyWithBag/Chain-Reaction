extends MenuGUI

@onready var player_amount_selector: Control = %PlayerAmount
@onready var choose_map_display: Control = %ChooseMapDisplay
@onready var maps_option_button: MapsOptionButton = choose_map_display.get_node("%MapsOptionButton")

var player_amount: int: 
	get: 
		return player_amount_selector.player_amount


func _ready(): 
	GameManager.current_state = GameManager.State.MENU
	CameraManager.current_camera = get_tree().current_scene.get_node("%Cameras/Camera2D")
	UIManager.set_gui_active(UIManager.player_screen, false)
	simulate_game_world_in_background() 
	GameManager.pause_game(false)
	BackgroundAudioManager.play_music(AudioEffectsLoader.get_music("Angel Eyes")) 


func simulate_game_world_in_background() -> void: 
	UndoHistoryManager.reset() 
	ChainReactionSequenceManager.reset()
	AtomPlayerTurnsManager.reset()
	AtomPlayersManager.reset()
	var game_start_data: GameStartData = GameStartData.new(
		MapsLoader.get_map("Game World 1"), 
		GameMode.new(GameMode.VS_PLAYERS), 
		2
	)
	AtomPlayersManager.start_game(game_start_data.player_amount)
	GameplayManager.current_gameplay_game_start_data = game_start_data
	GameplayManager.winnable = false
	GameManager.current_state = GameManager.State.MENU


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
		GameMode.new(GameMode.VS_AI), 
		player_amount
	)
	GameManager.game_start_data = game_start_data


func _on_start_game_pressed() -> void:
	GameManager.game_start_data.map_data = MapsLoader.get_map(maps_option_button.get_item_text(maps_option_button.selected)) 
	GameManager.start_game()
	
	
