extends GUI

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") 


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	UIManager.remove_gui(self)


