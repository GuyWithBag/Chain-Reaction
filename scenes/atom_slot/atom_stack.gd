extends Node
class_name AtomStack

signal initialized

signal atom_count_resetted(atom_amount_reseted: int)
signal atoms_back_to_zero

signal atoms_added(atom_amount_added: int)
signal atoms_removed(atom_amount_removed: int)

signal atoms_maxxed
signal atoms_overloaded

@export var atom_count: int = 0: 
	set(value): 
		if Engine.is_editor_hint(): 
			atoms_sprites = $"../AtomsSprites"
		var previous_count: int = atom_count
		atom_count = value
		if atom_count == max_atom_stack: 
			atoms_maxxed.emit() 
		if atom_count <= 0: 
			var state_machine: StateMachine = owner.state_machine
			state_machine.change_state(state_machine.get_state("Empty"))
			atoms_sprites.set_atoms_visible(false)
			atoms_back_to_zero.emit()
		if atom_count > 0: 
			atoms_added.emit(atom_count - previous_count)
			AtomSlotsManager.atom_added.emit(atom_count - previous_count)
		if atom_count > max_atom_stack: 
			atom_count = 0
			atoms_overloaded.emit()
		if stack_label: 
			stack_label.text = str(atom_count)
		atoms_sprites.arrange_atoms()
		
		
@export_range(1, 4) var max_atom_stack: int = 3: 
	set(value): 
		if value <= 0: 
			printerr("AtomStack (%s): max_atom_stack is set to 0. There is something wrong in the code. " % owner.name)
		max_atom_stack = clamp(value, 1, 4)

@export var stack_label: Label
@export var max_stack_label: Label
@export var name_label: Label

@onready var atoms_sprites: Node2D = $"../AtomsSprites"
@onready var atoms_detector: AtomsDetector = get_node("../AtomsDetector")

var _initialized: bool = false

func _ready() -> void: 
	if owner.name.split("@").size() == 1:
		return
	name_label.text = owner.name.split("@")[2]


# Called from GameWorld and AtomSprite's child_entered_tree signal
func init() -> void: 
	var atom_slots: Array[AtomSlot] = atoms_detector.get_slot_in_all_directions()
	var atom_slots_count: int = atom_slots.size()
	max_atom_stack = (atom_slots_count - 1)
	if max_stack_label: 
		max_stack_label.text = str(max_atom_stack)
	initialized.emit()
	_initialized = true


func set_atoms(atom_count: int) -> void: 
	pass
	

func add_atom(added_atoms: int, new_player: AtomPlayer) -> void: 
	var previous_count: int = atom_count
	atom_count += added_atoms
	var prev_player: AtomPlayer = owner.atom_player

	if prev_player:
		owner.remove_from_group(prev_player.group_name)
	owner.add_to_group(new_player.group_name)
#	new_player.current_total_atoms = AtomPlayersManager.get_current_total_atoms_count(new_player)
	# The colonizer will then receive their new atom amount
	owner.atom_player = new_player 
	for atom_player in AtomPlayersManager.atom_players_in_play: 
		var atom_count: int = AtomPlayersManager.get_current_total_atoms_count(atom_player)
		atom_player.current_total_atoms = atom_count
	# If the count becomes 0, it means that the current/previous atom player of this will lose some atoms
#	if prev_player != new_player && prev_player != null: 
#		prev_player.current_total_atoms -= previous_count
#		new_player.current_total_atoms += previous_count
##		new_player.current_total_atoms -= previous_count
#	elif prev_player == null: 
#		pass
#	else: 
#		new_player.current_total_atoms += added_atoms
	atoms_sprites.arrange_atoms()
	save_atom_slot_data()
	
	
func save_atom_slot_data() -> void: 
	if ChainReactionSequenceManager.is_chain_reacting: 
		ChainReactionSequenceManager.chain_reaction_sequence_finished.connect(
			func(): 
				UndoHistoryManager.save_current_data(owner) 
				
		, CONNECT_ONE_SHOT
		) 
	else: 
		UndoHistoryManager.save_current_data(owner) 


func remove_atoms(atoms_amout_to_remove: int) -> void: 
	atom_count -= atoms_amout_to_remove
	atoms_removed.emit(atoms_amout_to_remove)
	atoms_sprites.arrange_atoms()
	
	
func reset_atom_count() -> void: 
	owner.atom_player.current_total_atoms -= atom_count
	var prev_count: int = atom_count
	atom_count = 0
	atom_count_resetted.emit(prev_count)
	atoms_sprites.arrange_atoms()
	
	
func is_maxxed() -> bool: 
	if atom_count == max_atom_stack - 1: 
		return true
	return false
