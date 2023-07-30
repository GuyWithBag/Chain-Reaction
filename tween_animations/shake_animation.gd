extends Node
class_name ShakeAnimation
	
signal animation_started
signal animation_finished
	
enum PositionType {
	GLOBAL, 
	LOCAL
}

var playing: bool = true
var loops: int

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init(_loops: int = 0) -> void: 
	loops = _loops
	
	
static func shake_object_randomly(parent: Node, _loops: int, object: Object, position_type: PositionType, center_position: Vector2, shaking_duration: float, min_range: int, max_range: int) -> ShakeAnimation: 
	var shake_anim: ShakeAnimation = ShakeAnimation.new(_loops) 
	parent.add_child(shake_anim)
	shake_anim._shake_object_randomly(object, position_type, center_position, shaking_duration, min_range, max_range)
	return shake_anim
	
	
func _shake_object_randomly(object: Object, position_type: PositionType, center_position: Vector2, shaking_duration: float, min_range: int, max_range: int) -> void: 
	var property: String
	match position_type: 
		PositionType.GLOBAL: 
			property = "global_position" 
		PositionType.LOCAL: 
			property = "position"
	var loop_count: int = 0
	animation_started.emit()
	var tween: Tween = create_tween().bind_node(self)
	while playing == true: 
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
		# If loops are 0, then it will run infinitly until it is stopped. 
		if loops > 0: 
			if loop_count >= loops: 
				break
	tween.tween_property(object, property, center_position, shaking_duration)
	tween.play()
	animation_finished.emit()
	queue_free() 
	
	
static func shake_object_from_two_points(parent: Node2D, _loops: int, object: Object, position_type: PositionType, center_position: Vector2, from: Vector2, to: Vector2, shaking_duration: float) -> ShakeAnimation: 
	var shake_anim: ShakeAnimation = ShakeAnimation.new(_loops)
	parent.add_child(shake_anim)
	shake_anim._shake_object_from_two_points(object, position_type, center_position, from, to, shaking_duration)
	return shake_anim
	
	
func _shake_object_from_two_points(object: Object, position_type: PositionType, center_position: Vector2, from: Vector2, to: Vector2, shaking_duration: float) -> void: 
	var property: String
	match position_type: 
		PositionType.GLOBAL: 
			property = "global_position" 
		PositionType.LOCAL: 
			property = "position"
			
	var loop_count: int = 0
	var tween: Tween = create_tween().bind_node(self)
	while playing == true: 
		tween.tween_property(object, property, center_position + from, shaking_duration)
		tween.chain()
		tween.tween_property(object, property, center_position + to, shaking_duration)
		tween.play()
		
		await tween.finished
		tween.stop()
		loop_count += 1
		if loops > 0: 
			if loop_count >= loops: 
				tween.tween_property(object, property, center_position, shaking_duration)
				tween.play()
				await tween.finished
				break
	queue_free()


func stop() -> void: 
	playing = false
	
	
