## gameManager is where it handles the game's states. The process mode of this is in always. 
extends Node

signal world_ready(world: GameWorld)

signal max_atoms_in_map_changed(max: int)
signal current_atoms_set(amount: int)

signal quitted_to_main_menu

signal game_started
signal game_retried


var pausable: bool = true
var first_time_launched: bool
var debug: bool = false

var max_atoms_in_map: int = 0: 
	set(value): 
		max_atoms_in_map = value
		max_atoms_in_map_changed.emit(max_atoms_in_map)

var current_atoms: int = 0: 
	set(value): 
		current_atoms = value
		current_atoms_set.emit(current_atoms)

var world: GameWorld: 
	set(value): 
		world = value
		world_ready.emit(world)

var map_scaler: MapScaler

var extend_map: bool = false

var current_game_start_data: GameStartData

@export var state_chart: StateChart
@export var current_state: State
@export var playing: State
@export var paused: State


func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_ALWAYS
	MobileAds.initialize()
	UIManager.init()


func _input(_event: InputEvent) -> void: 
	if Input.is_action_just_pressed("screenshot"): 
		var image: Image = get_viewport().get_texture().get_image() 
		var path: String = "D:/Folders/Assets/Chain Reaction Assets/assets/playstore graphics/screenshots/" 
		image.save_png("%s/screenshot_%s.png" % [path, Time.get_ticks_usec()])


func start_game(start_data: GameStartData) -> void: 
	#if game_start_data == null: 
		#printerr("GameManager: Set game_start_data first before starting a game. ")
		#return
	#pause_game(false)
	reset_global_datas() 
	#PlayersManager.start_game(game_start_data.player_amount)
	current_game_start_data = start_data
	
	SceneManager.change_scene_to_file(current_game_start_data.get_appropriate_display_map_data())
	game_started.emit()


func pause_game(value: bool) -> void: 
	if !pausable: 
		return
	get_tree().paused = value
	print("GameManager: Scene is paused: ", get_tree().paused)
	
	
func reset_global_datas() -> void: 
	#GameplayManager.reset()
	pass


func quit_game() -> void:
	get_tree().quit()


func retry_game() -> void:
	#game_start_data = GameplayManager.current_gameplay_game_start_data
	#GameManager.start_game()
	#game_retried.emit()
	pass


func quit_to_main_menu() -> void: 
	retry_game()
	SceneManager.change_scene_to_file("res://gui/main_menu/main_menu.tscn")
	quitted_to_main_menu.emit()
	
	
func retry_game_prompt(yes_pressed: Callable = func() :, no_pressed: Callable = func() :) -> void: 
	var alert: AlertScreen = UIManager.create_alert(
		"Are you sure you want to retry the game?", 
		retry_game
	)
	alert.yes.pressed.connect(yes_pressed)
	alert.no.pressed.connect(no_pressed)
	
	
func quit_to_main_menu_prompt(yes_pressed: Callable = func() :, no_pressed: Callable = func() :) -> void: 
	var alert: AlertScreen = UIManager.create_alert(
		"Are you sure you want to quit to the main menu?", 
		quit_to_main_menu
	)
	alert.yes.pressed.connect(yes_pressed)
	alert.no.pressed.connect(no_pressed)
	
	
func quit_game_prompt(yes_pressed: Callable = func() :, no_pressed: Callable = func() :) -> void: 
	var alert: AlertScreen = UIManager.create_alert(
		"Are you sure you want to exit the game?", 
		quit_game
	)
	alert.yes.pressed.connect(yes_pressed)
	alert.no.pressed.connect(no_pressed)


func save_data() -> Dictionary: 
	var data: Dictionary = {
		
	}
	return data


func _on_menu_state_entered() -> void:
	pause_game(false)


func _on_playing_state_entered() -> void:
	pause_game(false)


func _on_pause_state_entered() -> void:
	pause_game(true)


func is_playing() -> bool: 
	return playing.active
	
	
func is_paused() -> bool: 
	return paused.active
