extends Resource
class_name AtomTeam

var team_number: int 
var team_color: Color
var total_atoms: int

func _init(_team_number: int, _team_color: Color) -> void: 
	team_number = _team_number
	team_color = _team_color
