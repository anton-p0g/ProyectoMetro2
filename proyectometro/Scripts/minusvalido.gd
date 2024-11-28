extends Node3D

func _process(delta: float) -> void:
	var animation_player = get_node("AnimationPlayer")
	animation_player.play("wheelchair-sit")
