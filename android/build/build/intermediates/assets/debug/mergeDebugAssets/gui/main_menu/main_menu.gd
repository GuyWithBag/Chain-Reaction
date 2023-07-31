extends MenuGUI


var player_amount: int: 
	get: 
		return player_amount_selector.player_amount
var extend_map: bool = false

@onready var player_amount_selector: Control = %PlayerAmount
@onready var choose_map_display: Control = %ChooseMapDisplay
@onready var maps_option_button: MapsOptionButton = choose_map_display.get_node("%MapsOptionButton")
@onready var extend_map_toggle: Control = %ExtendMapToggle


func _ready(): 
	LocalDatabase.init() 
	MobileAds.load_banner("Main Menu Banner")
	MobileAds.show_banner() 
	GameManager.current_state = GameManager.State.MENU
	CameraManager.current_camera = get_node("%Cameras/Camera2D")
	UIManager.set_gui_active(UIManager.player_screen, false)
	simulate_game_world_in_background() 
	GameManager.pause_game(false)
	BackgroundAudioManager.play_music(AudioEffectsLoader.get_music("Angel Eyes")) 
	extend_map = extend_map_toggle.get_node("CheckBox").button_pressed


func simulate_game_world_in_background() -> void: 
	UndoHistoryManager.reset() 
	ChainReactionSequenceManager.reset()
	AtomPlayerTurnsManager.reset()
	AtomPlayersManager.reset()
	var game_start_data: GameStartData = GameStartData.new(
		GameMode.new(GameMode.VS_PLAYERS), 
		2, 
		MapsLoader.get_map("Standard World")
	)
	AtomPlayersManager.start_game(game_start_data.player_amount)
	GameplayManager.current_gameplay_game_start_data = game_start_data
	GameManager.current_state = GameManager.State.MENU


func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _on_vs_players_pressed() -> void: 
	var game_start_data: GameStartData = GameStartData.new(
		GameMode.new(GameMode.VS_PLAYERS), 
		player_amount
	)
	GameManager.game_start_data = game_start_data


func _on_vs_ai_pressed() -> void:
	var game_start_data: GameStartData = GameStartData.new(
		GameMode.new(GameMode.VS_AI), 
		player_amount
	)
	GameManager.game_start_data = game_start_data


func _on_start_game_pressed() -> void:
	GameManager.game_start_data.extend_map = extend_map
	var map_selected: String = maps_option_button.get_item_text(maps_option_button.selected)
	var map_data: MapData = MapsLoader.get_map(map_selected) 

	GameManager.game_start_data.map_data = map_data
	GameManager.start_game() 


func _on_extend_map_check_box_toggled(button_pressed: bool) -> void:
	extend_map = button_pressed
#	$CanvasLayer/Control/CenterContainer/MainBody/Pages/ChooseMapPage/StartGame.grab_focus()


func _on_rate_us_pressed() -> void:
	if OS.get_name() == "iOS":
		OS.shell_open("https://itunes.apple.com/app/idYOUR_APP_ID?action=write-review")
	else:
		OS.shell_open("https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME")

