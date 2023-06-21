extends GUI
class_name AtomCounterEffect

var count: int = 0: 
	set(value): 
		count = value
		if count <= 0: 
			return
		counter.text = str(count)
		
@onready var counter: Label = get_node("Counter") 


func _ready() -> void: 
	AtomSlotsManager.atom_slot_exploded.connect(_on_atom_slot_exploded)
	ChainReactionSequenceManager.chain_reaction_sequence_finished.connect(_on_chain_reaction_sequence_finished)
	
	
func _on_atom_slot_exploded(atom_slot: AtomSlot) -> void: 
	UIManager.set_gui_active(self, true)
	count += 1
	self.modulate.a = 1
	var new_color: Color
#	var shader: ShaderMaterial 
	# Shader has not been implemented yet
	if count > 12: 
		new_color = Color.WHITE 
	elif count > 10: 
		new_color = Color.ROYAL_BLUE 
	elif count > 8: 
		new_color = Color.GOLD
	elif count > 6: 
		new_color = Color.INDIGO
	elif count > 4: 
		new_color = Color.YELLOW_GREEN
	elif count > 0: 
		new_color = atom_slot.atom_player.team_color
	var tween: Tween = create_tween()
	var shake_animation: ShakeAnimation = ShakeAnimation.new(self, true, 3) 
	var orig_position: Vector2 = global_position
	grow_to_size(tween, self, 0.3, 0.1)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(counter, "theme_override_colors/font_color", new_color, 0.2)
	tween.play()
	shake_animation.shake_object_randomly(self, ShakeAnimation.PositionType.GLOBAL, orig_position, 0.1, 3, 15)


func _on_chain_reaction_sequence_finished() -> void: 
	await get_tree().create_timer(1).timeout
	count = 0
	var tween: Tween = create_tween()
	var orig_modulate: Color = self.modulate
	var invisible_modulate: Color = orig_modulate
	invisible_modulate.a = 0
	tween.tween_property(self, "modulate", invisible_modulate, 1)
	tween.play()
	await tween.finished 
	UIManager.set_gui_active(self, false)


func grow_to_size(tween: Tween, node: Node, to_size: float, grow_duration: float) -> void: 
	var grow_to_scale: Vector2 = node.scale + Vector2(to_size, to_size) 
	tween.tween_property(node, "scale", grow_to_scale, grow_duration)
	
	
