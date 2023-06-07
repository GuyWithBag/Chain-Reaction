extends Control

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func play_anim(anim_name: String, speed: int = 1) -> bool:
	if speed < 0:
		animation_player.play(anim_name, -1, abs(speed), true)
		await animation_player.animation_finished
		return true
	animation_player.play(anim_name, -1, speed, false)
	await animation_player.animation_finished
	return true
