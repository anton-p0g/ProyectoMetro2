extends Control

@onready var menu = $Filtro_Clicks
@onready var animationPlayer = $AnimationPlayer
@onready var popup = $"../RoutePopup"

func _on_button_pressed() -> void:
	if popup.visible == true:
		popup.visible = false
		
	if menu.visible == true:
		animationPlayer.play_backwards("show_menu")
		await animationPlayer.animation_finished
		menu.visible = false
	else:
		menu.visible = true
		animationPlayer.play("show_menu")




func _on_main_menu_pressed() -> void:
	Transition.transition_to("res://Scenes/Gui/StartMenuScreen.tscn")

func _on_exit_pressed() -> void:
		get_tree().quit()
