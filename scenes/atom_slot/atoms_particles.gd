extends Node2D
class_name AtomsParticles 

var particles: Dictionary = {
	"retro_explosion" : "res://particles/retro_explosion/retro_explosion.tscn"
}


func play_particle(particle_name: String, to_global_position: Vector2) -> void: 
	var game_world: GameWorld = GameManager.game_world 
	var particle_id: String = particle_name.to_snake_case() 
	if !particles.has(particle_id): 
		printerr("AtomsParticles: %s particle cannot be found" % particle_name) 
		return
	var particle: GPUParticles2D = load(particles[particle_id]).instantiate() 
	var atom_particles: Node2D = game_world.atom_particles
	var atom_particles_group: Node2D = Node2D.new()
	atom_particles.add_child(atom_particles_group)
	atom_particles_group.add_child(particle)
	var team_color: Color = AtomPlayerTurnsManager.current_atom_player_in_turn.team_color
	team_color.s = 0.5
	atom_particles_group.modulate = team_color
	atom_particles_group.global_position = to_global_position 
	particle.emitting = true
	await get_tree().create_timer(particle.lifetime).timeout
	particle.queue_free() 

