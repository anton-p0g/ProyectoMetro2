extends VBoxContainer

@onready var day_selector = $SeleccionDia
@onready var hour_selector = $VBoxContainer/Spinbox_Hora
@onready var minute_selector = $VBoxContainer/Spinbox_Minutos

func _ready() -> void:
	var days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
	for day in days:
		day_selector.add_item(day)
		
	# Defino 2 signals para detectar cambios de día u hora
	day_selector.connect("item_selected", Callable(self, "_on_day_selected"))
	hour_selector.connect("value_changed", Callable(self, "_on_hour_changed"))

	_set_defaults()
	

func _set_defaults():
	var date_time = Time.get_datetime_dict_from_system()
	var current_day = date_time["weekday"] 	# 1 = Lunes, 7 = Domingo
	var current_hour = date_time["hour"]
	var current_minute = date_time["minute"]
	
	day_selector.select(current_day - 1)
	_update_hour_limits(current_day)
		
	if current_hour < hour_selector.min_value:
		current_hour = hour_selector.min_value
		current_minute = max(30, current_minute)
	elif current_hour > hour_selector.max_value:
		current_hour = hour_selector.max_value
		current_minute = min(30, current_minute)
	
	hour_selector.value = current_hour
	_update_minute_limits(current_day, current_hour, current_minute)
	

func _on_day_selected(index):
	_update_hour_limits(index + 1)	# Empieza a contar desde 1 en vez de 0
	_update_minute_limits(index + 1, hour_selector.value, minute_selector.value)


func _on_hour_changed(value):
	# Actualiza intervalos de minutos si se cambia la hora
	var selected_day = day_selector.get_selected_id() + 1
	_update_minute_limits(selected_day, value, minute_selector.value)
	

func _update_hour_limits(day_of_week):
	hour_selector.step = 1
	
	if day_of_week in range(1,6): # De lunes a Viernes
		hour_selector.min_value = 5
		hour_selector.max_value = 22
	elif day_of_week == 6: # Sábado
		hour_selector.min_value = 6
		hour_selector.max_value = 22
	elif day_of_week == 7: # Domingo
		hour_selector.min_value = 8
		hour_selector.max_value = 20
		

func _update_minute_limits(day_of_week, current_hour, current_minute):
	if day_of_week in range(1,6):
		if current_hour == 5: # Abre 5:30
			minute_selector.min_value = 30
			minute_selector.max_value = 59
		elif current_hour == 22: # Cierra 22:30
			minute_selector.min_value = 0
			minute_selector.max_value = 30
		else:
			minute_selector.min_value = 0
			minute_selector.max_value = 59
	
	elif day_of_week == 6:
		if current_hour == 6: # Abre 6:30
			minute_selector.min_value = 30
			minute_selector.max_value = 59
		elif current_hour == 22: # Cierra 22:30
			minute_selector.min_value = 0
			minute_selector.max_value = 30
		else:
			minute_selector.min_value = 0
			minute_selector.max_value = 59
	elif day_of_week == 7:
		if current_hour == 8: # Abre 8:30
			minute_selector.min_value = 30
			minute_selector.max_value = 59
		elif current_hour == 20: # Cierra 22:30
			minute_selector.min_value = 0
			minute_selector.max_value = 30
		else:
			minute_selector.min_value = 0
			minute_selector.max_value = 59
	
	# Si el minuto actual está fuera del rango
	if current_minute < minute_selector.min_value:
		minute_selector.value = minute_selector.min_value
	elif current_minute > minute_selector.max_value:
		minute_selector.value = minute_selector.max_value
	else:
		minute_selector.value = current_minute # Preserva el minuto original correcto
		
