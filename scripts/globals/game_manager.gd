extends Node

signal max_atoms_in_map_changed(max: int)
signal current_atoms_set(amount: int)

signal quitted_to_main_menu

signal game_started
signal game_retried

signal current_state_changed(new_game_state: State, old_game_state: State)

enum State {
	MENU,
	PAUSED, 
	IN_GAME, 
}

var max_atoms_in_map: int = 0: 
	set(value): 
		max_atoms_in_map = value
		max_atoms_in_map_changed.emit(max_atoms_in_map)

var current_atoms: int = 0: 
	set(value): 
		current_atoms = value
		current_atoms_set.emit(current_atoms)

var game_world: GameWorld

var game_start_data: GameStartData

const UNIT_SIZE: int = 32

var pausable: bool = true
var first_time_launched: bool

var current_state: State = State.MENU: 
	set(value): 
		current_state_changed.emit(value, current_state)
		current_state = value
		
var map_scaler: MapScaler


func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_ALWAYS
	UIManager.init()


func start_game() -> void: 
	if game_start_data == null: 
		printerr("GameManager: Set game_start_data first before starting a game. ")
		return
	pause_game(false)
	ChainReactionSequenceManager.reset()
	AtomPlayerTurnsManager.reset()
	AtomPlayersManager.reset()
	
	AtomPlayersManager.start_game(game_start_data.player_amount)
	GameplayManager.current_gameplay_game_start_data = game_start_data
	get_tree().change_scene_to_file(game_start_data.map_data.map_url)
	game_started.emit()
	game_start_data = null


func pause_game(value: bool) -> void: 
	if !pausable: 
		return
	get_tree().paused = value
	print("GameManager: Scene is paused: ", get_tree().paused)


func quit_game() -> void:
	get_tree().quit()


func retry_game() -> void:
	game_start_data = GameplayManager.current_gameplay_game_start_data
	GameManager.start_game()
	game_retried.emit()


func quit_to_main_menu() -> void: 
	retry_game()
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")
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
	
	
