extends Node

signal max_atoms_in_map_changed(max: int)
signal current_atoms_set(amount: int)

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

var game_start_data: GameStartData = GameStartData.new(
	MapsLoader.get_map("Game World 1"), 
	GameMode.new(0), 
	2
)

func start_game() -> void: 
	if game_start_data == null: 
		printerr("GameManager: Set game_start_data first before starting a game. ")
		return
	AtomTeamsManager.start_game(game_start_data.player_amount)
	GameplayManager.current_gameplay_game_start_data = game_start_data
	get_tree().change_scene_to_file(game_start_data.map_data.map_url)
	game_started.emit()
	game_start_data = null


const UNIT_SIZE: int = 32

var pausable: bool = true
var first_time_launched: bool

var current_state: State = State.MENU: 
	set(value): 
		current_state_changed.emit(value, current_state)
		current_state = value


func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_ALWAYS
	UIManager.init()


func pause_game(value: bool) -> void: 
	if !pausable: 
		return
	get_tree().paused = value
	print("GameManager: Scene is paused: ", get_tree().paused)


func quit_game() -> void:
	get_tree().quit()


func retry_game() -> void:
	game_start_data = GameplayManager.current_gameplay_game_start_data
	ChainReactionSequenceManager.reset()
	AtomTeamTurnsManager.reset()
	AtomTeamsManager.reset()
	GameManager.start_game()
	game_retried.emit()

