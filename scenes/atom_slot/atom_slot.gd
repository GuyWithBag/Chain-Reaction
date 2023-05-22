extends Node2D
class_name AtomSlot

@onready var atoms_sprites: Node2D = get_node("AtomsSprites")
@onready var atom_stack: AtomStack = get_node("AtomStack")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 
@onready var hitbox: Area2D = get_node("Hitbox")
@onready var grid: Sprite2D = get_node("Grid")
@onready var atom_detector: Node2D = get_node("AtomsDetector") 
@onready var state_machine: StateMachine = get_node("StateMachine")

var atom_team: AtomTeam = AtomTeam.new(
		1, 
		Color(0, 0, 0)
	)

var available_directions: Array[String] = []
var to_explode: bool = false

func _ready() -> void: 
	state_machine.init(self)
	atom_detector.init(self)
	atom_stack.atoms_added.connect(_on_atom_added)
	atom_stack.initialized.connect(_on_atom_stack_initialized)


func _on_atom_stack_initialized() -> void: 
	pass


func _on_touch_screen_button_pressed() -> void:
	interact()


func interact() -> void: 
	atom_stack.add_atom(1, atom_team)


func _on_atom_added() -> void: 
	change_sprites_modulation(atom_team.team_color)
	
	
func change_sprites_modulation(new_modulate: Color) -> void: 
	atoms_sprites.modulate = new_modulate
	
	
