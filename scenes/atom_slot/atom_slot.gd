@icon("res://resources/tilesets/grid_slot.png")
extends Node2D
class_name AtomSlot

signal initialized
signal player_interacted 

signal player_interacted_wrong_team
signal atom_placed

@export var atom_slot_group_label: Label 

var atom_player: AtomPlayer: 
	set(value): 
		previous_atom_player = atom_player
		atom_player = value
		atoms_sprites.change_team_color_to(atom_player)
		if atom_player != null: 
			if previous_atom_player != null:
				if !get_groups().is_empty(): 
					remove_from_group(previous_atom_player.group_name)
			add_to_group(atom_player.group_name)
			
			atom_slot_group_label.text = str(atom_player.team_number)


var previous_atom_player: AtomPlayer

var available_directions: Array[String] = [] 

var _initialized: bool = false
var neighbor_atom_slots: Array[AtomSlot]
var available_directions_to_neighbors: Array[int]

@onready var atoms_sprites: AtomsSprites = get_node("AtomsSprites")
@onready var atom_stack: AtomStack = get_node("AtomStack")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 
@onready var hitbox: Area2D = get_node("Hitbox")
@onready var grid: Sprite2D = get_node("Grid")
@onready var atom_detector: AtomsDetector = get_node("AtomsDetector") 
@onready var state_machine: StateMachine = get_node("StateMachine")
@onready var sequence: ChainReactionSequence = ChainReactionSequence.new(self)
@onready var atoms_positions: AtomPositions = get_node("AtomPositions")



func _ready() -> void: 
	atoms_positions.center_position.global_position = self.global_position
	state_machine.init(self)
	atom_detector.init(self)
	
	# When this condition is fulfilled, all atom_slots will be initialized. 


func _physics_process(_delta): 
	if _initialized == false: 
		# If all the slots have their physics initialized, do this. 
		var parent: TileMap = get_parent()
		var children: Array[Node] = parent.get_children()
		var index: int = children.find(self) + 1
		var size: int = children.size()
		if index >= size: 
			for child in children: 
				child.init()


func init() -> void: 
	atom_stack.init()
	atoms_sprites.init()
	state_machine.get_state("Explode").finished_exploding.connect(
		func(): 
			AtomSlotsManager.atom_slot_exploded.emit(self)
	)
	neighbor_atom_slots = atom_detector.get_slot_in_all_directions()
	available_directions_to_neighbors = atom_detector.get_available_directions()
	atom_detector.queue_free_all_raycasts() 
	_initialized = true
	initialized.emit()


func _on_touch_screen_button_pressed() -> void:
#	var current_atom_player: AtomPlayer = AtomPlayerTurnsManager.current_atom_player_in_turn
	#shake_grid()
	player_interact()


func shake_grid() -> void: 
	if get_tree().current_scene.has_node("%Root"): 
		var root: Control = get_tree().current_scene.get_node("%Root")
		var cam_shake: ShakeAnimation = ShakeAnimation.shake_object_randomly(self, 2, root, ShakeAnimation.PositionType.GLOBAL, root.global_position, 0.07, 3, 25)
		cam_shake.animation_finished.connect(
			func(): 
				root.global_position = Vector2.ZERO
		, CONNECT_ONE_SHOT
		)


func player_interact() -> void: 
	player_interacted.emit()
	if AtomPlayerTurnsManager.is_chain_reacting(): 
		if GameManager.debug: 
			print("AtomSlot (%s): NOT YET" % name)
		return
	var current_atom_player: AtomPlayer = AtomPlayerTurnsManager.current_atom_player_in_turn
	if state_machine.current_state == state_machine.get_state("ReadyToExplode") && atom_player == current_atom_player: 
		shake_grid()
	# This is for when it is empty, it will do the placed atom animation
	if atom_player == current_atom_player || state_machine.current_state == state_machine.get_state("Empty"): 
		atom_player = current_atom_player
		var tween: Tween = create_tween() 
		var orig_scale: Vector2 = atoms_sprites.atom_sprites_group.scale
		atoms_sprites.atom_sprites_group.scale = orig_scale + Vector2(0.5, 0.5)
		tween.tween_property(atoms_sprites.atom_sprites_group, "scale", orig_scale, 0.1)
		atoms_sprites.flash_tween(0.1, false, 1)
	elif state_machine.current_state == state_machine.get_state("Empty"): 
		atom_player = current_atom_player
		if GameManager.debug: 
			print("AtomSlot (%s): Is indeed empty" % name)
	elif atom_player != current_atom_player: 
		if GameManager.debug: 
			print("AtomSlot (%s): WRONG TEAM" % name)
		var map_scale: Vector2 = GameManager.map_scaler.vector2_scale_relative_to_tilemap_size - Vector2(120, 120) 
		var center_global_position: Vector2 = atoms_positions.center_position.global_position
		var from: Vector2 = Vector2(map_scale.x, 0) 
		var to: Vector2 = Vector2(-map_scale.x, 0) 
		var _shake_animation: ShakeAnimation = ShakeAnimation.shake_object_from_two_points(self, 1, atoms_sprites.atom_sprites_group, ShakeAnimation.PositionType.GLOBAL, center_global_position, from, to, 0.03)
		player_interacted_wrong_team.emit()
		return
	if GameManager.debug: 
		print("AtomSlot (%s): Placed atom here" % name)
	atom_stack.add_atom(1, atom_player) 
	atom_placed.emit()
	if AtomPlayerTurnsManager.is_awaiting_turn(): 
		AtomPlayerTurnsManager.next_turn()
	atom_player.total_atoms_added += 1
	
	
#func flash_tween() -> void: 
#	var tween: Tween = create_tween() 
#	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
#	tween.tween_property(self, "modulate", atom_player.team_color, 0.1)
#	tween.play()


func apply_undo_changes(atom_slot_data: AtomSlotData) -> void: 
	if atom_slot_data == null: 
		atom_stack.atom_count = 0
		atom_player = null
		state_machine.change_state(state_machine.get_state("Empty"))
		return
#	print(atom_slot.atom_stack.atom_count)
	atom_stack.atom_count = atom_slot_data.atom_count 
	atom_player = atom_slot_data.atom_player
	state_machine.change_state(atom_slot_data.current_state) 


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
