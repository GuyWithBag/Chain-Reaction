extends Label


func _ready() -> void:
	visible = false
	if OS.is_debug_build(): 
		visible = true


