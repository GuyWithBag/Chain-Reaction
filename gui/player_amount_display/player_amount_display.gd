@tool
extends Control

@export var atom_count: int = 2: 
	set(value): 
		atom_count = value
		if Engine.is_editor_hint(): 
			positions = get_node("Positions")
			sprites = get_node("Sprites")
		if positions == null || sprites == null: 
			return
		set_all_atoms_visible(false)
		if atom_count <= 0: 
			return
		if atom_count > 7: 
			pass
		set_all_atom_colors()
		arrange_atoms()
		pad_animations.animate_atoms_from_atom_count()
		
		
var sprites_children: Array[Node] = []: 
	get: 
		return sprites.get_children()
		
var positions_children: Array[Node] = []: 
	get: 
		return positions.get_children()
		
var rng: RandomNumberGenerator = RandomNumberGenerator.new() 

@onready var positions: Control = get_node("Positions") 
@onready var sprites: Control = get_node("Sprites") 
@onready var tween_animations: TweenAnimations = get_node("TweenAnimations")
@onready var pad_animations: PlayerAmountDisplayAnimations = get_node("PlayerAmountDisplayAnimations")

func _ready(): 
	if Engine.is_editor_hint(): 
		positions = get_node("Positions")
		sprites = get_node("Sprites")
	atom_count = 2
	arrange_atoms()
	set_all_atom_colors()
	pad_animations.animate_atoms_from_atom_count()


func _process(delta): 
	if Engine.is_editor_hint(): 
		positions = get_node("Positions")
		sprites = get_node("Sprites")
		arrange_atoms()


func set_all_atoms_visible(value: bool) -> void: 
	for sprite in sprites.get_children(): 
		sprite.visible = value


func arrange_atoms() -> void: 
	match atom_count: 
		1: 
			arrange_atoms_to_position_group(0)
		2: 
			arrange_atoms_to_position_group(1)
		3: 
			arrange_atoms_to_position_group(2)
		4: 
			arrange_atoms_to_position_group(3)
		5: 
			arrange_atoms_to_position_group(4)
		6: 
			arrange_atoms_to_position_group(5)
		7: 
			arrange_atoms_to_position_group(6)



	

func arrange_atom_in_random(atom: Control) -> void: 
	var snap: int = 40
	var rand_position: Vector2 = Vector2(rng.randi_range(0, int(size.x)) % snap, rng.randi_range(0, int(size.y)) % snap)
	atom.global_position = rand_position
	
	
func arrange_atoms_to_position_group(position_group: int) -> void: 
	for index in atom_count: 
		sprites_children[index].show()
		sprites_children[index].global_position = positions_children[position_group].get_children()[index].global_position


func _on_player_amount_player_amount_changed(previous_amount: int, new_amount: int):
	atom_count = new_amount


func set_all_atom_colors() -> void: 
	for i in sprites_children.size(): 
		change_atom_color_to_player(i)


func change_atom_color_to_player(player_num: int) -> void: 
	if player_num + 1 > 5: 
		return
	sprites_children[player_num].modulate = AtomPlayersManager.atom_player_colors[player_num + 1]
	
	
