extends Control

signal loaded
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Menu.visible = false


func _input(event) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed() and $StartScreen.visible == true:
		show_menu()

func show_menu():
	# Oculta el menú inicial
	$StartScreen.visible = false
	
	$AnimationPlayer.play("startMenu")
	$Menu.visible = true

func activate() -> void:
	pass

func load_scene() -> void:
	await get_tree().create_timer(0.1).timeout
	loaded.emit()

func _on_start_pressed() -> void:
	Transition.transition_to("res://Scenes/estacion_entrada.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
