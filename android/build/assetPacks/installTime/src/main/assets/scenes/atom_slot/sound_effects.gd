extends Node

@export var atom_slot_player_interacted_wrong_team: AudioStream
@export var atom_slot_placed: Array[AudioStream]
@export var started_exploding: Array[AudioStream] 
@export var atoms_added: Array[AudioStream]
@export var player_has_been_eliminated: AudioStream

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var is_player_interacted: bool = false

@onready var audio_stream_player: AudioStreamPlayer = get_node("AudioStreamPlayer")  


func _ready() -> void: 
	AtomPlayersManager.player_has_been_eliminated.connect(_on_player_has_been_eliminated)
	
	
func _on_player_has_been_eliminated(_atom_player: AtomPlayer, _atom_players_in_turn: Array[AtomPlayer]) -> void: 
	if (owner.atom_player in AtomPlayersManager.atom_players) == false: 
		return
	BackgroundAudioManager.play_temporary_sound(player_has_been_eliminated)


func _on_atom_slot_player_interacted_wrong_team() -> void: 
	if GameManager.current_state != GameManager.State.IN_GAME: 
		return
	is_player_interacted = true
	BackgroundAudioManager.play_temporary_sound(atom_slot_player_interacted_wrong_team)


func _on_atom_slot_atom_placed() -> void: 
	play_random_sound(atom_slot_placed)


func _on_explode_started_exploding() -> void:
	play_random_sound(started_exploding)


func _on_atom_stack_atoms_added(_atom_amount_added) -> void:
	play_random_sound(atoms_added) 


func play_random_sound(rand_range: Array[AudioStream]) -> void: 
	rng.randomize()
	var rand: int = randi_range(0, rand_range.size() - 1)
	BackgroundAudioManager.play_temporary_sound(rand_range[rand])
	
	
