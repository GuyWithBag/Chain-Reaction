extends Node


var data: Dictionary = {
	"retro_explosion" : load("res://particles/retro_explosion/retro_explosion.tscn")
}


func get_particle(particle_name: String) -> PackedScene: 
	var particle_id: String = particle_name.to_snake_case() 
	if !data.has(particle_id): 
		printerr("ParticleEffectsLoader: %s particle cannot be found" % particle_name) 
		return null
	return data[particle_id] 

