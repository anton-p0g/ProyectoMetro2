extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation_player = get_node("AnimationPlayer")
	animation_player.play("walk")
