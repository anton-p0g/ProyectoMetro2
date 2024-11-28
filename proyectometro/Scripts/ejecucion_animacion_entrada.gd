extends Node3D

@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

func activate() -> void:
	pass
	
signal loaded()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func load_scene() -> void:
	await get_tree().create_timer(0.1).timeout
	loaded.emit()


func _process(delta: float) -> void:
	if path_follow_3d.progress_ratio >= 0.92:
		Transition.transition_to("res://Scenes/SeleccionEstaciones.tscn")
