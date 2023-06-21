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
		
var max_atoms_can_display: int = 11
		
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
	atom_count = 2
	init() 
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void: 
	init()


func init() -> void: 
	if Engine.is_editor_hint(): 
		positions = get_node("Positions")
		sprites = get_node("Sprites")
		pad_animations = get_node("PlayerAmountDisplayAnimations")
	arrange_atoms()
	set_all_atom_colors()
	pad_animations.animate_atoms_from_atom_count()


func _process(_delta) -> void: 
	if Engine.is_editor_hint(): 
		positions = get_node("Positions")
		sprites = get_node("Sprites")
		arrange_atoms()


func set_all_atoms_visible(value: bool) -> void: 
	for sprite in sprites.get_children(): 
		sprite.visible = value


func arrange_atoms() -> void: 
	if atom_count >= max_atoms_can_display: 
		arrange_atoms_to_position_group(max_atoms_can_display, max_atoms_can_display - 1)
		return
	arrange_atoms_to_position_group(atom_count, atom_count - 1)


func arrange_atom_in_random(atom: Control) -> void: 
	var snap: int = 40
	var rand_position: Vector2 = Vector2(rng.randi_range(0, int(size.x)) % snap, rng.randi_range(0, int(size.y)) % snap)
	atom.global_position = rand_position
	
	
func arrange_atoms_to_position_group(count: int, position_group: int) -> void: 
	for index in count: 
		sprites_children[index].show()
		sprites_children[index].global_position = positions_children[position_group].get_children()[index].global_position


func _on_player_amount_player_amount_changed(_previous_amount: int, new_amount: int):
	atom_count = new_amount


func set_all_atom_colors() -> void: 
	for i in sprites_children.size(): 
		change_atom_color_to_player(i)


func change_atom_color_to_player(player_num: int) -> void: 
	if Engine.is_editor_hint(): 
		return
	if player_num > AtomPlayersManager.atom_player_colors.size() - 1: 
		sprites_children[player_num].modulate = AtomPlayersManager.get_random_color() 
		return
	sprites_children[player_num].modulate = AtomPlayersManager.atom_player_colors[str(player_num + 1)]
	
	
