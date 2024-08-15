extends CanvasLayer
class_name GameWorld

# TODO: Have it so that it will stop being able to add when map is already full
# Have it count the total number of atoms present in each team and total of all of them

@export var change_state_to_playing: bool = true
@export var game_starter: GameStarter

@onready var tilemaps: Node2D = get_node("%TileMaps")
@onready var atom_sprites: Node = %AtomSprites
@onready var atom_particles: Node2D = %AtomParticles
@onready var cameras: Node2D = $Cameras

#var atom_slot_groups: Array[AtomSlotGroup] = []

func _ready() -> void: 
	GameManager.world = self
	if change_state_to_playing: 
		GameManager.state_chart.send_event("play")
	game_starter.start()
	CameraManager.current_camera = cameras.get_child(0)
#	InGameStateManager.chain_reaction_sequence_finished.connect(
#		func(): 
#			tilemap.modulate = PlayersManager.current_player_in_turn.team_color
#	)
	
#	var atom_slot_group: AtomSlotGroup = AtomSlotGroup.new(0)
#	get_all_neighboring_cells(atom_slot_group, Vector2i(544, 290))

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
