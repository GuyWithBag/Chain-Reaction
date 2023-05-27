extends Node

signal started_shaking
signal finished_shaking

var rng: RandomNumberGenerator = RandomNumberGenerator.new() 

var current_camera: Camera2D: 
	set(value): 
		current_camera = value 
		original_position = current_camera.global_position
		
var original_position: Vector2
var shaking: bool = false

func shake_camera(shaking_duration: float = 0.1, loops: int = 4, min_range: int = 1, max_range: int = 7) -> Tween: 
	var shake_tween: Tween = create_tween().set_loops(loops).set_ease(Tween.EASE_OUT)
	
	rng.randomize()
	var x_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
	var x_rand_pos: int = rng.randi_range(min_range, max_range) * x_rand_dir
	
	rng.randomize()
	var y_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
	var y_rand_pos: int = rng.randi_range(min_range, max_range) * y_rand_dir
	
	var new_position: Vector2 = Vector2(x_rand_pos, y_rand_pos)
	shake_tween.tween_property(current_camera, "position", original_position + new_position, shaking_duration)
	shake_tween.tween_property(current_camera, "position", original_position, shaking_duration)
	shake_tween.finished.connect(
		func(): 
			finished_shaking.emit()
			shaking = false
	, CONNECT_ONE_SHOT
	)
	shake_tween.play()
	shaking = true
	started_shaking.emit()
	
	return shake_tween
	
	
