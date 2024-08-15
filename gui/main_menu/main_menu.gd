extends MenuGUI

@export var menu_world: GameWorld

@export var player_amount_selector: PlayerAmountSelector
@export var choose_map_display: Control
@export var maps_option_button: MapsOptionButton = choose_map_display.get_node("%MapsOptionButton")
@export var extend_map_toggle: Control

var player_amount: int: 
	get: 
		return player_amount_selector.player_amount
var extend_map: bool = false
var game_start_data: GameStartData


func _ready(): 
	LocalDatabase.init() 
	show_ad_banner() 
	GameManager.state_chart.send_event("menu")
	CameraManager.current_camera = get_node("%Cameras/Camera2D")
	UIManager.set_gui_active(UIManager.player_screen, false)
	simulate_game_world_in_background() 
	GameManager.pause_game(false)
	BackgroundAudioManager.play_music(AudioEffectsLoader.get_music("Angel Eyes")) 
	extend_map = extend_map_toggle.get_node("CheckBox").button_pressed
	AdsManager.load_interstitial_ad(AdID.new().set_android_id("ca-app-pub-9490685140858860/1729832023"))


func show_ad_banner() -> void: 
	AdsManager.load_show_banner(AdID.new().set_android_id("ca-app-pub-9490685140858860/9077892909"), AdSize.BANNER, AdPosition.Values.TOP)
	pass


func simulate_game_world_in_background() -> void: 
	var start_data: GameStartData = GameStartData.new(
		GameMode.new(GameMode.VS_PLAYERS), 
		2, 
		MapsLoader.get_map("Standard World")
	)
	menu_world.game_starter.start(start_data)
	#managers.gameplay.current_gameplay_game_start_data = start_data


func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _on_vs_players_pressed() -> void: 
	var _game_start_data: GameStartData = GameStartData.new(
		GameMode.new(GameMode.VS_PLAYERS), 
		player_amount
	)
	game_start_data = _game_start_data


func _on_vs_ai_pressed() -> void:
	var _game_start_data: GameStartData = GameStartData.new(
		GameMode.new(GameMode.VS_AI), 
		player_amount
	)
	game_start_data = _game_start_data


func _on_start_game_pressed() -> void:
	game_start_data.extend_map = extend_map
	var map_selected: String = maps_option_button.get_item_text(maps_option_button.selected)
	var map_data: MapData = MapsLoader.get_map(map_selected) 

	game_start_data.map_data = map_data
	GameManager.start_game(game_start_data) 
	AdsManager.banner.destroy()


func _on_extend_map_check_box_toggled(button_pressed: bool) -> void:
	extend_map = button_pressed
#	$CanvasLayer/Control/CenterContainer/MainBody/Pages/ChooseMapPage/StartGame.grab_focus()


func _on_rate_us_pressed() -> void:
	if OS.get_name() == "iOS":
		OS.shell_open("https://itunes.apple.com/app/idYOUR_APP_ID?action=write-review")
	else:
		OS.shell_open("https://play.google.com/store/apps/details?id=org.MacchiMatchaProductions.ChainReactionAtomRevampedSupreme&hl=en&gl=US")

