extends Node2D
class_name AtomsParticles 


func play_particle(particle_name: String, to_global_position: Vector2, lifetime_duration: float = 0.6) -> void: 
#	var world: GameWorld = GameManager.world 
#	var particle_id: String = particle_name.to_snake_case() 
	var particle: GPUParticles2D = ParticleEffectsLoader.get_particle(particle_name).instantiate() 
	particle.process_material.lifetime_randomness = lifetime_duration
	var atom_particles: Node2D = get_tree().current_scene.get_node("%AtomParticles")
	var atom_particles_group: Node2D = Node2D.new()
	atom_particles.add_child(atom_particles_group)
	atom_particles_group.add_child(particle)
	var current_team_color: Color = AtomPlayerTurnsManager.current_atom_player_in_turn.team_color
	var team_color: Color = current_team_color
	if owner.previous_atom_player: 
		if owner.previous_atom_player.team_color != current_team_color: 
			team_color = owner.previous_atom_player.team_color
	atom_particles_group.modulate = team_color
	atom_particles_group.global_position = to_global_position 
	particle.emitting = true
	await get_tree().create_timer(particle.lifetime).timeout
	particle.queue_free() 

