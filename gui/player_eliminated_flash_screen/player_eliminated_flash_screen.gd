extends Control


func _ready() -> void:
	AtomPlayersManager.player_has_been_eliminated.connect(_on_player_has_been_eliminated)


func _on_player_has_been_eliminated(atom_player: AtomPlayer, atom_players_in_play: Array[AtomPlayer]) -> void: 
	pass


func _set_vignette_rgb(rgb: Color) -> void: 
	pass
	
	
func _set_vignette_opacity(opacity: float) -> void: 
	pass
	
	
