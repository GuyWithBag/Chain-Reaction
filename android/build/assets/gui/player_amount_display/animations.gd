extends Node
class_name TweenAnimations

enum Directions {
	LEFT = -1, 
	RIGHT = 1
}

var _shaking: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()





#func stop_shaking_atoms() -> void: 
#	_shaking = false
#	global_position = atom_positions.center_position.global_position


func rotate_object(object: Object, rotation_direction, full_rotation_duration: float = 9, override_rotation_direction: int = 0) -> Tween: 
	rng.randomize()
	var tween: Tween = create_tween().set_loops()
	if override_rotation_direction != 0: 
		tween.tween_property(object, "rotation", TAU * override_rotation_direction, full_rotation_duration).as_relative()
	else: 
		tween.tween_property(object, "rotation", TAU * rotation_direction, full_rotation_duration).as_relative()
	tween.play()
	return tween




