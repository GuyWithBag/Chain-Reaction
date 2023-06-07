extends Node
class_name PlayerAmountDisplayAnimations

var sprites_children: Array[Node] = []: 
	get: 
		return sprites.get_children()
		
var positions_children: Array[Node] = []: 
	get: 
		return positions.get_children()
		
var rng: RandomNumberGenerator = RandomNumberGenerator.new() 

var shake_animations: Array = []
var rotate_animations: Array[Tween] = []

@onready var positions: Control = owner.get_node("Positions") 
@onready var sprites: Control = owner.get_node("Sprites") 
@onready var tween_animations: TweenAnimations = owner.get_node("TweenAnimations")


func animate_atoms_from_atom_count() -> void: 
	_stop_shake_animations()
	_stop_rotate_animations()
	match owner.atom_count: 
		2: 
			shake_animations.append_array(shake_all_atoms_individually(0.1, 1, 7))
			rotate_animations.append(rotate_all_sprites_randomly(7))
		3: 
			shake_animations.append(shake_all_atoms(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		4: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		5: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		6: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		7: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		8: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		9: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
		10: 
			shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
			rotate_animations.append(rotate_all_sprites_randomly())
	if owner.atom_count >= owner.max_atoms_can_display:
		shake_animations.append_array(shake_all_atoms_individually(0.05, 3, 20))
		rotate_animations.append(rotate_all_sprites_randomly())
			
			
func _stop_shake_animations() -> void: 
	for animation in shake_animations: 
		animation.playing = false
		shake_animations.erase(animation)
		animation.queue_free()
	
	
func _stop_rotate_animations() -> void: 
	for animation in rotate_animations: 
		animation.stop()
	
	
func shake_all_atoms(shake_duration: float, min_range: int, max_range: int) -> ShakeAnimation: 
	var shake_animation: ShakeAnimation = ShakeAnimation.new(self) 
	add_child(shake_animation)
	shake_animation.shake_object_randomly(sprites, ShakeAnimation.PositionType.LOCAL, sprites.position, shake_duration, min_range, max_range) 
	return shake_animation
	
	
func shake_all_atoms_individually(shake_duration: float, min_range: int, max_range: int) -> Array: 
	var shake_animations: Array = []
	for i in owner.atom_count: 
		if owner.atom_count >= owner.max_atoms_can_display:
			i = 10
		var sprite: Control = sprites_children[i]
		var shake_animation: ShakeAnimation = ShakeAnimation.new(self) 
		add_child(shake_animation)
		shake_animation.shake_object_randomly(sprite, shake_animation.PositionType.LOCAL, sprite.position, shake_duration, min_range, max_range) 
		shake_animations.append(shake_animation)
	return shake_animations
	
	
func rotate_all_sprites_randomly(rotate_duration: float = 9) -> Tween: 
	var rotate_direction: int = tween_animations.Directions.values()[rng.randi_range(0, 1)]
	return rotate_all_sprites(rotate_direction, rotate_duration)
	
	
func rotate_all_sprites(rotate_direction: int, rotate_duration: float = 9) -> Tween: 
	return tween_animations.rotate_object(sprites, rotate_direction, rotate_duration) 
