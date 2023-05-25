@tool
extends Node
class_name AtomStack

signal initialized

signal atoms_count_reseted
signal atoms_added
signal atoms_maxxed
signal atoms_over_added

@export var atom_count: int = 0: 
	set(value): 
		if Engine.is_editor_hint(): 
			atoms_sprites = $"../AtomsSprites"
		var _previous_count: int = atom_count
		if value == max_atom_stack - 1: 
			atoms_maxxed.emit()
		if atom_count <= 0: 
			atoms_count_reseted.emit()
		atom_count = clamp(value, 0, max_atom_stack)
		if atom_count > 0: 
			atoms_added.emit()
		if atom_count >= max_atom_stack: 
			atom_count = 0
			atoms_over_added.emit()
		if stack_label:
			stack_label.text = str(atom_count)
#		atoms_sprites.hide_and_show_atoms_logic(atom_count, previous_count)
		atoms_sprites.arrange_atoms()

@export_range(1, 4) var max_atom_stack: int = 4

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
	max_atom_stack = atom_slots_count
	if max_stack_label: 
		max_stack_label.text = str(max_atom_stack)
	initialized.emit()
	_initialized = true


func add_atom(atom_amount: int, new_team: AtomTeam) -> void: 
	atom_count += atom_amount
	owner.atom_team = new_team


func reset_atom_count() -> void: 
	atom_count = 0
	atoms_count_reseted.emit()
	
	
func is_maxxed() -> bool: 
	if atom_count == max_atom_stack - 1: 
		return true
	return false
