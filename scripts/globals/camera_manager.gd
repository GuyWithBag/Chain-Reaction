extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new() 

var current_camera: Camera2D: 
	set(value): 
		current_camera = value 
		original_position = current_camera.global_position
		
var original_position: Vector2


func shake_camera(shaking_duration: float = 0.1, loops: int = 4) -> void: 
	var shake_tween: Tween = create_tween().set_loops(loops) 
	var min_range: int = 1 
	var max_range: int = 7
	
	rng.randomize()
	var x_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
	var x_rand_pos: int = rng.randi_range(min_range, max_range) * x_rand_dir
	
	rng.randomize()
	var y_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
	var y_rand_pos: int = rng.randi_range(min_range, max_range) * y_rand_dir
	
	var new_position: Vector2 = Vector2(x_rand_pos, y_rand_pos)
	shake_tween.tween_property(current_camera, "position", original_position + new_position, shaking_duration)
	shake_tween.tween_property(current_camera, "position", original_position, shaking_duration)
	shake_tween.play()
	
	
