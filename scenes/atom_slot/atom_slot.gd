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
		if  atom_player != null:
			if previous_atom_player != null:
				remove_from_group(StringName(str(previous_atom_player.team_number)))
			add_to_group(StringName(str(atom_player.team_number)))
			atom_slot_group_label.text = str(atom_player.team_number)


var previous_atom_player: AtomPlayer

var available_directions: Array[String] = [] 

var _initialized: bool = false

@onready var atoms_sprites: Node2D = get_node("AtomsSprites")
@onready var atom_stack: AtomStack = get_node("AtomStack")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 
@onready var hitbox: Area2D = get_node("Hitbox")
@onready var grid: Sprite2D = get_node("Grid")
@onready var atom_detector: Node2D = get_node("AtomsDetector") 
@onready var state_machine: StateMachine = get_node("StateMachine")
@onready var sequence: ChainReactionSequence = ChainReactionSequence.new(self)


func _ready() -> void: 
	state_machine.init(self)
	atom_detector.init(self)
	state_machine.get_state("Explode").finished_exploding.connect(_on_finished_exploding)


func _physics_process(_delta): 
	if _initialized == false: 
		init()


func init() -> void: 
	atom_stack.init()
	_initialized = true
	initialized.emit()


func _on_finished_exploding() -> void: 
	for atom_player_in_play in AtomPlayersManager.atom_players_in_play: 
		var atom_count: int = AtomPlayersManager.get_total_atoms_count(atom_player_in_play)
		print("AtomSlot: Atom Team: %s, Atom Count: %s" % [atom_player_in_play.team_number, atom_count])
		if atom_count <= 0: 
			printerr("Eliminate team: ", atom_player_in_play.team_number)
			AtomPlayersManager.elimnate_team(atom_player_in_play)


func _on_touch_screen_button_pressed() -> void:
	player_interact()


func player_interact() -> void: 
	player_interacted.emit()
	if AtomPlayerTurnsManager.is_chain_reacting(): 
		print("AtomSlot (%s): NOT YET" % name)
		return
	var current_atom_player: AtomPlayer = AtomPlayerTurnsManager.current_atom_player_in_turn
	if state_machine.current_state == state_machine.get_state("Empty"): 
		atom_player = current_atom_player
		print("AtomSlot (%s): Is indeed empty" % name)
	elif atom_player != current_atom_player: 
		print("AtomSlot (%s): WRONG TEAM" % name)
		return
	print("AtomSlot (%s): Placed atom here" % name)
	atom_stack.add_atom(1, atom_player) 
	atom_added.emit() 
	if AtomPlayerTurnsManager.is_awaiting_turn(): 
		AtomPlayerTurnsManager.next_turn()
	
	
