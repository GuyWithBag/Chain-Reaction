extends CanvasLayer
class_name GameWorld

# TODO: Have it so that it will stop being able to add when map is already full
# Have it count the total number of atoms present in each team and total of all of them

@onready var tilemaps: Node2D = get_node("%TileMaps")
@onready var atom_sprites: Node2D = %AtomSprites
@onready var atom_particles: Node2D = %AtomParticles
@onready var cameras: Node2D = $Cameras

@onready var tilemap: TileMap = tilemaps.get_node("AtomSlotsTileMap")

@onready var total_atom_slots: int = tilemap.get_used_cells(0).size()

#var atom_slot_groups: Array[AtomSlotGroup] = []

func _ready() -> void: 
	GameManager.game_world = self
	change_grid_modulate_to_current_team_in_turn()
	AtomPlayerTurnsManager.changed_current_atom_player_in_turn.connect(_on_changed_current_atom_player_in_turn)
	GameManager.current_state = GameManager.State.IN_GAME
	UIManager.set_gui_active(UIManager.player_screen, true)
	CameraManager.current_camera = cameras.get_child(0)
	GameplayManager.winnable = true
#	InGameStateManager.chain_reaction_sequence_finished.connect(
#		func(): 
#			tilemap.modulate = AtomPlayersManager.current_atom_player_in_turn.team_color
#	)
	
#	var atom_slot_group: AtomSlotGroup = AtomSlotGroup.new(0)
#	get_all_neighboring_cells(atom_slot_group, Vector2i(544, 290))
	
	
func _on_changed_current_atom_player_in_turn(_previous_atom_player: AtomPlayer, _current_atom_player: AtomPlayer) -> void: 
	if AtomPlayerTurnsManager.is_chain_reacting(): 
		await ChainReactionSequenceManager.chain_reaction_sequence_finished
	animate_change_grid_modulate_to_current_team_in_turn() 
	
	
func animate_change_grid_modulate_to_current_team_in_turn() -> void: 
	if AtomPlayerTurnsManager.current_atom_player_in_turn == null: 
		return
	var tween: Tween = create_tween() 
	tween.tween_property(tilemap, "modulate", AtomPlayerTurnsManager.current_atom_player_in_turn.team_color, 0.3)
	
	
func change_grid_modulate_to_current_team_in_turn() -> void: 
	if AtomPlayerTurnsManager.current_atom_player_in_turn == null: 
		return
	tilemap.modulate = AtomPlayerTurnsManager.current_atom_player_in_turn.team_color
	
	
#func get_all_neighboring_cells(atom_slot_group: AtomSlotGroup, coords: Vector2) -> void: 
#	atom_slot_groups.append(atom_slot_group)
#	print(coords)
#	atom_slot_group.exceptions.append(coords)
#	print(atom_slot_group.exceptions)
#	print("\n")
#	for neighbor in [TileSet.CELL_NEIGHBOR_TOP_SIDE, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE, TileSet.CELL_NEIGHBOR_RIGHT_SIDE, TileSet.CELL_NEIGHBOR_LEFT_SIDE]: 
#		var cell_pos: Vector2 = tilemap.get_neighbor_cell(coords, neighbor) as Vector2
#		var cell
#		if atom_slot_group.exceptions.has(cell_pos): 
#			continue
#		atom_slot_group.exceptions.append(cell_pos)
#		get_all_neighboring_cells(atom_slot_group, cell_pos)
#
#
#class AtomSlotGroup: 
#	var group_num: int
#	var exceptions: Array[Vector2] = []
#
#	func _init(_group_num: int) -> void:
#		group_num = _group_num


	
	
