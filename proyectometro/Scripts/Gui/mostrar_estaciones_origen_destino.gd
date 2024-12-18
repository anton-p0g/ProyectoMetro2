extends Node

signal loaded()

# Called when the node enters the scene tree for the first time.
func activate() -> void:
	pass
	

func load_scene() -> void:
	await get_tree().create_timer(0.1).timeout
	loaded.emit()

@onready var target_nodes = [
	$"Mapa/conexiones/2652",
	$"Mapa/conexiones/2756",
	$"Mapa/conexiones/2862",
	$"Mapa/conexiones/2970",
	$"Mapa/conexiones/3080",
	$"Mapa/conexiones/158400",
	$"Mapa/conexiones/178200",
	$"Mapa/conexiones/101200",
	$"Mapa/conexiones/252000",
	$"Mapa/conexiones/67200",
	$"Mapa/conexiones/54000",
	$"Mapa/conexiones/49000",
	$"Mapa/conexiones/1722",
	$"Mapa/conexiones/1806",
	$"Mapa/conexiones/1892",
	$"Mapa/conexiones/1980",
	$"Mapa/conexiones/992",
	$"Mapa/conexiones/1056",
	$"Mapa/conexiones/1122",
	$"Mapa/conexiones/1190",
	$"Mapa/conexiones/1260",
	$"Mapa/conexiones/1332",
	$"Mapa/conexiones/1406",
	$"Mapa/conexiones/1482",
	$"Mapa/conexiones/462",
	$"Mapa/conexiones/650",
	$"Mapa/conexiones/600",
	$"Mapa/conexiones/552",
	$"Mapa/conexiones/506",
	$"Mapa/conexiones/240",
	$"Mapa/conexiones/306",
	$"Mapa/conexiones/272",
	$"Mapa/conexiones/210",
	$"Mapa/conexiones/182",
	$"Mapa/conexiones/156",
	$"Mapa/conexiones/132",
]
@onready var mas_button = $MasInfo
@onready var popup2 = $RoutePopup

signal inicio_animacion
var ejecucion_animacion = false
@onready var mapa: Node2D = $Mapa


func _ready() -> void:
	$NodoRuta/CalcularRuta.connect("pressed", Callable(self, "_button_combined"))
	mas_button.connect("pressed", Callable(self, "_toggle_pop_up_window"))
	mas_button.visible = false

func on_calcular_ruta_button_pressed():
	var origen = $NodoRuta/SeleccionarRuta/Origen/listaEstaciones
	var destino = $NodoRuta/SeleccionarRuta/Destino/listaEstaciones
	
	var id_origen = origen.get_selected_id()
	var id_destino = destino.get_selected_id()
	
	var day_selector = $NodoRuta/SeleccionarHora/SeleccionDia
	var hour_selector = $NodoRuta/SeleccionarHora/HBoxContainer/Spinbox_Hora
	var minute_selector = $NodoRuta/SeleccionarHora/HBoxContainer/Spinbox_Minutos
	
	var selected_day = day_selector.get_selected_id() + 1  # Convert to 1-based index
	var selected_hour = hour_selector.value
	var selected_minute = minute_selector.value
	
	GlobalData.selected_hour = str(selected_hour)
	GlobalData.selected_minute = str(selected_minute)
	
	var python_call = preload("res://Scripts/python_call.gd").new()
	python_call.run_python_script(id_origen, id_destino, selected_day, selected_hour, selected_minute)
	


func make_arist(list_stations_id: Array) -> Array:
	var lista_conjunta = Array()
	var list_id_arist = Array()
	var list_id_train_animation = Array()
	for i in range(len(list_stations_id) - 1):
		if str(list_stations_id[i])[0] == str(list_stations_id[i + 1])[0]:
			list_id_arist.append("Mapa/conexiones/" + str(list_stations_id[i] * list_stations_id[i + 1]))
			if list_stations_id[i] > list_stations_id[i + 1]:
				var direction_animation = Array()
				direction_animation.append("Mapa/animacion_metro/" + str(list_stations_id[i] * list_stations_id[i + 1]))
				direction_animation.append(1)
				list_id_train_animation.append(direction_animation)
			else:
				var direction_animation = Array()
				direction_animation.append("Mapa/animacion_metro/" + str(list_stations_id[i] * list_stations_id[i + 1]))
				direction_animation.append(-1)
				list_id_train_animation.append(direction_animation)
		else:
			list_id_arist.append("Mapa/conexiones/" + str(list_stations_id[i] * list_stations_id[i + 1] * 100))
			if list_stations_id[i] > list_stations_id[i + 1]:
				var direction_animation = Array()
				direction_animation.append("Mapa/animacion_metro/" + str(list_stations_id[i] * list_stations_id[i + 1] * 100))
				direction_animation.append(1)
				list_id_train_animation.append(direction_animation)
			else:
				var direction_animation = Array()
				direction_animation.append("Mapa/animacion_metro/" + str(list_stations_id[i] * list_stations_id[i + 1] * 100))
				direction_animation.append(-1)
				list_id_train_animation.append(direction_animation)

	lista_conjunta.append(list_id_arist)
	lista_conjunta.append(list_id_train_animation)
	return lista_conjunta 

func _on_button_pressed():
	for node in target_nodes:
		if node:
			node.visible = false
		else:
			print("Node not found")

func desocultar(lista_aristas):
	for arista in lista_aristas:
		var nodo = get_node(arista)
		nodo.visible = true

func animar_tren(nodos, direcciones):
	for arista in range(len(nodos.get_children())):
		nodos.get_children()[arista].inicializar = 0
		nodos.get_children()[arista].direction = direcciones[arista]
		nodos.get_children()[arista].is_moving = true
		await nodos.get_children()[arista].animacion_tren

func ultimo_nodo(nodos):
	return nodos.get_children()[-1]

func crear_animacion(lista_animacion_train):
	var nodo_animacion = Node2D.new()
	mapa.add_child(nodo_animacion)
	var direcciones = Array()
	for arista in lista_animacion_train:
		var nodo = get_node(arista[0])
		direcciones.append(arista[1])
		var clone = nodo.duplicate()
		nodo_animacion.add_child(clone)
	var resultado = [nodo_animacion, direcciones]
	return resultado
		

func _button_combined():
	_on_button_pressed()
	on_calcular_ruta_button_pressed()
	var ruta = GlobalData.path
	var tiempo = GlobalData.travel_duration
	if not ejecucion_animacion:
		var id_path = GlobalData.path_ids
		var lista_conjunta = make_arist(id_path)
		var lista_aristas = lista_conjunta[0] 
		var lista_animacion_train = lista_conjunta[1]
		desocultar(lista_aristas)
		var resultado = crear_animacion(lista_animacion_train)
		ejecucion_animacion = true
		animar_tren(resultado[0], resultado[1])
	else:
		var nodo_ultimo = ultimo_nodo(mapa)
		nodo_ultimo.queue_free()
		ejecucion_animacion = false
		if not ejecucion_animacion:
			var id_path = GlobalData.path_ids
			var lista_conjunta = make_arist(id_path)
			var lista_aristas = lista_conjunta[0] 
			var lista_animacion_train = lista_conjunta[1]
			desocultar(lista_aristas)
			var resultado = crear_animacion(lista_animacion_train)
			ejecucion_animacion = true
			animar_tren(resultado[0], resultado[1])
			
	_show_button_mas_info()
	print(GlobalData.grouped_path[0])
	var start_station = GlobalData.grouped_path[0]["stations"][0]
	var final_station = GlobalData.grouped_path[-1]["stations"][-1]
	popup2.populate_popup(start_station, GlobalData.grouped_path, final_station, GlobalData.transfers)
	

func _show_button_mas_info():
	mas_button.visible = true
	
func _toggle_pop_up_window():
	if popup2.visible:
		popup2.hide()
	else:
		popup2.show_popup()

func _on_route_popup_close_requested() -> void:
	popup2.hide()
