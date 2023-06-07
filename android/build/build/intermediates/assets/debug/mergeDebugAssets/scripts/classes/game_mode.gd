extends Resource
class_name GameMode

enum {
	VS_PLAYERS, 
	VS_AI, 
	VS_ONLINE
}

var mode: int 

func _init(_mode: int) -> void: 
	mode = _mode
	
	
	
