extends GUI

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"flash": 
			UIManager.remove_gui(self)


