extends Node

var music: Dictionary = {
	"arcade_machines" : load("res://audio/music/arcade-machines-classic-arcade-game-116836.mp3"), 
	"angel_eyes" : load("res://audio/music/kim-lightyear-angel-eyes-chiptune-edit-110226.mp3")
}

var sfx: Dictionary = {
	"explosion_1" : load("res://audio/explosion1.wav"), 
	"explosion_2" : load("res://audio/explosion2.wav"), 
	"explosion_3" : load("res://audio/explosion3.wav"), 
	"explosion_4" : load("res://audio/explosion4.wav"), 
	"victory" : load("res://audio/victory.wav"), 
	"vine_boom" : load("res://audio/vine_boom.wav"), 
	"bruh" : load("res://audio/bruh.wav")
}


func get_music(music_name: String) -> AudioStream: 
	return music[music_name.to_snake_case()]
	
	
func get_sfx(sfx_name: String) -> AudioStream: 
	return sfx[sfx_name.to_snake_case()]
	
	
