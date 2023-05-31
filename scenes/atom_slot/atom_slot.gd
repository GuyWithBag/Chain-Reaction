extends Node2D
class_name AtomSlot

signal initialized
signal player_interacted 
signal atom_added

@export var atom_slot_group_label: Label 

var atom_player: AtomPlayer: 
	set(value): 
		previous_atom_player = atom_player
		atom_player = value
		atoms_sprites.change_team_color_to(atom_player)
		if atom_player != null:
			if previous_atom_player != null: 
				remove_from_group(StringName(str(previous_atom_player.team_number)))
			add_to_group(StringName(str(atom_player.team_number)))
			atom_slot_group_label.text = str(atom_player.team_number)


var previous_atom_player: AtomPlayer

var available_directions: Array[String] = [] 

var _initialized: bool = false

@onready var atoms_sprites: AtomsSprites = get_node("AtomsSprites")
@onready var atom_stack: AtomStack = get_node("AtomStack")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 
@onready var hitbox: Area2D = get_node("Hitbox")
@onready var grid: Sprite2D = get_node("Grid")
@onready var atom_detector: Node2D = get_node("AtomsDetector") 
@onready var state_machine: StateMachine = get_node("StateMachine")
@onready var sequence: ChainReactionSequence = ChainReactionSequence.new(self)
@onready var atoms_positions: AtomPositions = get_node("AtomPositions")


func _ready() -> void: 
	state_machine.init(self)
	atom_detector.init(self)


func _physics_process(_delta): 
	if _initialized == false: 
		init()


func init() -> void: 
	atom_stack.init()
	atoms_sprites.init()
	AtomSlotsManager.all_atom_slots[name] = self
	state_machine.get_state("Explode").finished_exploding.connect(
		func(): 
			AtomSlotsManager.atom_slot_exploded.emit(self)
	)
	_initialized = true
	initialized.emit()


func _on_touch_screen_button_pressed() -> void:
	var current_atom_player: AtomPlayer = AtomPlayerTurnsManager.current_atom_player_in_turn
	if state_machine.current_state == state_machine.get_state("ReadyToExplode") && atom_player == current_atom_player: 
		CameraManager.shake_camera(0.1, 3, 10, 25)
	player_interact()


func player_interact() -> void: 
	player_interacted.emit()
	if AtomPlayerTurnsManager.is_chain_reacting(): 
		print("AtomSlot (%s): NOT YET" % name)
		return
	var current_atom_player: AtomPlayer = AtomPlayerTurnsManager.current_atom_player_in_turn
	if atom_player == current_atom_player || state_machine.current_state == state_machine.get_state("Empty"): 
		atom_player = current_atom_player
		var tween: Tween = create_tween() 
		var orig_scale: Vector2 = atoms_sprites.atom_sprites_group.scale
		atoms_sprites.atom_sprites_group.scale = orig_scale + Vector2(0.5, 0.5)
		tween.tween_property(atoms_sprites.atom_sprites_group, "scale", orig_scale, 0.1)
		atoms_sprites.flash_tween(0.1, false, 1)
	elif state_machine.current_state == state_machine.get_state("Empty"): 
		atom_player = current_atom_player
		print("AtomSlot (%s): Is indeed empty" % name)
	elif atom_player != current_atom_player: 
		print("AtomSlot (%s): WRONG TEAM" % name)
		var shake_animation: ShakeAnimation = ShakeAnimation.new(self, 1, 3) 
		var map_scale: Vector2 = GameManager.map_scaler.vector2_scale_relative_to_tilemap_size
		var from: Vector2 = global_position + Vector2(map_scale.x, 0) 
		var to: Vector2 = global_position + Vector2(0, map_scale.y) 
		add_child(shake_animation)
		shake_animation.shake_object_from_two_points(atoms_sprites.atom_sprites_group, ShakeAnimation.PositionType.GLOBAL, atoms_positions.center_position.global_position, from, to, 0.1)
		return
#	flash_tween()
	print("AtomSlot (%s): Placed atom here" % name)
	atom_stack.add_atom(1, atom_player) 
	atom_added.emit()
	if AtomPlayerTurnsManager.is_awaiting_turn(): 
		AtomPlayerTurnsManager.next_turn()
	
	
#func flash_tween() -> void: 
#	var tween: Tween = create_tween() 
#	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
#	tween.tween_property(self, "modulate", atom_player.team_color, 0.1)
#	tween.play()


func apply_undo_changes(atom_slot_data: AtomSlotData) -> void: 
	print("%s : %s" % [name, atom_slot_data.atom_count])
	atom_stack.atom_count = atom_slot_data.atom_count 
	atom_player = atom_slot_data.atom_player
	
	
