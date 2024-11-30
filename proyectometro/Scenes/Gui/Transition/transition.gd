extends CanvasLayer

signal transitioned_in()
signal transitioned_out

@onready var animation_player: AnimationPlayer = $AnimationPlayer2

func transition_in() -> void:
	animation_player.play("transition_in")

func transition_out() -> void:
	animation_player.play("transition_out")

func transition_to(scene: String) -> void:
	transition_in()
	print("Awaiting")
	await transitioned_in
	
	var new_scene = load(scene).instantiate()
	var root: Window = get_tree().get_root()
	
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(new_scene)
	
	new_scene.load_scene()
	await new_scene.loaded
	
	transition_out()
	await transitioned_out
	
	new_scene.activate()
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("test")
	if anim_name == "transition_in":
		transitioned_in.emit()
	elif anim_name == "transition_out":
		transitioned_out.emit()
