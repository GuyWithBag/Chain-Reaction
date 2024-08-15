extends LocalManager
class_name GameplayManager

signal game_started(players: Array[Player])
signal game_ended(winner: Player, losers: Array[Player])

var just_undoed: bool = false
var first_atom_in_game_placed: bool = false

var game_round: int = 0; 

var win_screen: PackedScene = load("res://gui/win_screen/win_screen.tscn")
var winning_player: Player
var current_gameplay_game_start_data: GameStartData
var player_eliminated_flash_screen: PackedScene = load("res://gui/player_eliminated_flash_screen/player_eliminated_flash_screen.tscn")


func start(start_data: GameStartData) -> void: 
	current_gameplay_game_start_data = start_data
	managers.players.only_one_team_remaining.connect(_on_only_one_team_remaining)
	managers.players.player_has_been_eliminated.connect(_on_player_has_been_eliminated)
	

func reset() -> void: 
	game_round = 0


func _on_player_has_been_eliminated(eliminated_player: Player, _alive_teams: Array[Player]) -> void: 
	var flash_screen: GUI = player_eliminated_flash_screen.instantiate() 
	flash_screen.modulate = eliminated_player.team_color 
	UIManager.add_gui(flash_screen) 


func _unhandled_input(_event: InputEvent) -> void: 
	if GameManager.current_state != GameManager.State.IN_GAME: 
		return
	if Input.is_action_just_pressed("undo"): 
		just_undoed = true
		managers.undo_history.apply_undo_changes() 
	
	
func _on_only_one_team_remaining(last_remaining_player: Player) -> void: 
	if GameManager.current_state != GameManager.State.IN_GAME: 
		return
	end_game(last_remaining_player)


func end_game(winner: Player) -> void: 
	winning_player = winner
	UIManager.add_gui(win_screen.instantiate()) 
	game_ended.emit()
	
	
