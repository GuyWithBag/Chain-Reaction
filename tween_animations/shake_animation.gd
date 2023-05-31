extends Node
class_name ShakeAnimation
	
enum PositionType {
	GLOBAL, 
	LOCAL
}

var playing: bool = false
var bind: Node
var loops: int
var queue_free_after_shake_count: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _init(_bind: Node, _playing: bool = true, _queue_free_after_shake_count: int = 1, _loops: int = 0) -> void: 
	playing = _playing
	bind = _bind
	loops = _loops
	queue_free_after_shake_count = _queue_free_after_shake_count
	
	
func shake_object_randomly(object: Object, position_type: PositionType, center_position: Vector2, shaking_duration: float, min_range: int, max_range: int) -> void: 
	var property: String
	match position_type: 
		PositionType.GLOBAL: 
			property = "global_position" 
		PositionType.LOCAL: 
			property = "position"
	var loop_count: int = 0
	while playing == true: 
		if loops > 0: 
			if loop_count > loops: 
				break
		var tween: Tween = bind.create_tween().bind_node(self)
		rng.randomize()
		var x_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
		var x_rand_pos: int = rng.randi_range(min_range, max_range) * x_rand_dir

		rng.randomize()
		var y_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
		var y_rand_pos: int = rng.randi_range(min_range, max_range) * y_rand_dir
		var new_position: Vector2 = Vector2(x_rand_pos, y_rand_pos)
		tween.tween_property(object, property, center_position + new_position, shaking_duration)
		tween.tween_property(object, property, center_position, shaking_duration)
		tween.play()
		await tween.finished
		tween.stop()
		loop_count += 1
	queue_free_after_shake_count -= 1 
	if queue_free_after_shake_count == 0: 
		queue_free()
		
		
func shake_object_from_two_points(object: Object, position_type: PositionType, center_position: Vector2, from: Vector2, to: Vector2, shaking_duration: float, min_range: int = 1) -> void: 
	var property: String
	match position_type: 
		PositionType.GLOBAL: 
			property = "global_position" 
		PositionType.LOCAL: 
			property = "position"
			
	var loop_count: int = 0
	while playing == true: 
		var tween: Tween = bind.create_tween().bind_node(self)
		if loops > 0: 
			if loop_count > loops: 
				tween.tween_property(object, property, center_position, shaking_duration)
				break
		rng.randomize()
		var x_rand_from: int = rng.randi_range(min_range, from.x)
		
		rng.randomize()
		var y_rand_from: int = rng.randi_range(min_range, from.y)
		var rand_from: Vector2 = Vector2(x_rand_from, y_rand_from) 
		
		rng.randomize()
		var x_rand_to: int = rng.randi_range(min_range, to.x)
		
		rng.randomize()
		var y_rand_to: int = rng.randi_range(min_range, to.y)
		var rand_to: Vector2 = Vector2(x_rand_to, y_rand_to)
		
		tween.tween_property(object, property, center_position + rand_from, shaking_duration)
		tween.chain()
		tween.tween_property(object, property, center_position + rand_to, shaking_duration)
		tween.play()
		
		await tween.finished
		tween.stop()
		loop_count += 1
	queue_free_after_shake_count -= 1 
	if queue_free_after_shake_count == 0: 
		queue_free()

