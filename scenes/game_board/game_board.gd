extends CenterContainer
class_name GameBoard

@export var game_starter: GameStarter
@export var tilemaps: Node2D



func _on_changed_current_player_in_turn(_previous_player: Player, _current_player: Player) -> void: 
	var managers: LocalManagers = game_starter.managers
	if managers.player_turns.is_chain_reacting(): 
		await managers.chain_reaction_sequences.chain_reaction_sequence_finished
	animate_change_grid_modulate_to_current_team_in_turn() 
	
	
func animate_change_grid_modulate_to_current_team_in_turn() -> void: 
	var managers: LocalManagers = game_starter.managers
	if managers.player_turns.current_player_in_turn == null: 
		return
	var tween: Tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(tilemaps, "modulate", managers.player_turns.current_player_in_turn.team_color, 0.3)
	
	
func change_grid_modulate_to_current_team_in_turn() -> void: 
	var managers: LocalManagers = game_starter.managers
	if managers.player_turns.current_player_in_turn == null: 
		return
	tilemaps.modulate = managers.player_turns.current_player_in_turn.team_color
	
