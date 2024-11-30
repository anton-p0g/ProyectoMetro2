extends PathFollow3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var empezar = 0
@onready var character_male_d_2: Node3D = $"character-male-d2"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if empezar == 0:
		
		progress_ratio += delta*(0.80)
		
	if progress_ratio >= 97:
		empezar = 1
