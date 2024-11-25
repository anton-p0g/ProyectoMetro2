extends Node2D



@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

# Called when the node enters the scene tree for the first time.
@export var is_moving = false
@export var direction = 1
@export var inicializar = 0
@export var aceleracion: float = 0

signal animacion_tren

func _process(delta: float) -> void:
	if is_moving:
		if direction == -1:
			if inicializar == 0:
				path_follow_2d.progress_ratio = 1
				inicializar = 1
				
			path_follow_2d.visible = true
			var velocidad = -(delta*(0.1) + aceleracion)
			
			if path_follow_2d.progress_ratio > 0.8:
				path_follow_2d.progress_ratio += velocidad
				aceleracion += delta*(0.05)
			
			elif path_follow_2d.progress_ratio < 0.2:
				path_follow_2d.progress_ratio += velocidad
				aceleracion -= delta*(0.05)
			
			else:
				path_follow_2d.progress_ratio += velocidad
				
			if path_follow_2d.progress_ratio <= 0.05:
				is_moving = false
				await get_tree().create_timer(0.5).timeout
				path_follow_2d.progress_ratio = 1
				
		else:
			if inicializar == 0:
				path_follow_2d.progress_ratio = 0
				inicializar = 1
				
			path_follow_2d.visible = true
			var velocidad = delta*(0.1) + aceleracion
		
			if path_follow_2d.progress_ratio < 0.2:
				path_follow_2d.progress_ratio += velocidad
				aceleracion += delta*(0.05)
			
			elif path_follow_2d.progress_ratio > 0.8:
				path_follow_2d.progress_ratio += velocidad
				aceleracion -= delta*(0.05)
			
			else:
				path_follow_2d.progress_ratio += velocidad
		
			if path_follow_2d.progress_ratio >= 0.95:
				is_moving = false
				await get_tree().create_timer(0.5).timeout
				path_follow_2d.progress_ratio = 0
				
	else:
		animacion_tren.emit()
		path_follow_2d.visible = false
