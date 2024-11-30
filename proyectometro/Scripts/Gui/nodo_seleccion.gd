extends Control

@onready var selector_origen: OptionButton = get_node("../NodoRuta/SeleccionarRuta/Origen/listaEstaciones")
@onready var selector_destino: OptionButton = get_node("../NodoRuta/SeleccionarRuta/Destino/listaEstaciones")
@onready var mapa: Node2D = get_node("../Mapa")
@onready var flecha_origen = $FlechaOrigen
@onready var flecha_destino = $FlechaDestino

@onready var controladores_lineaA: Array = get_tree().get_nodes_in_group("lineaAControlador")
@onready var controladores_lineaB: Array = get_tree().get_nodes_in_group("lineaBControlador")
@onready var controladores_lineaC: Array = get_tree().get_nodes_in_group("lineaCControlador")
@onready var controladores_lineaD: Array = get_tree().get_nodes_in_group("lineaDControlador")
@onready var controladores_lineaE: Array = get_tree().get_nodes_in_group("lineaEControlador")

@onready var boton_origen = $Panel/BotonOrigen
@onready var boton_destino = $Panel/BotonDestino

@onready var pressed_style: StyleBox = boton_origen.get_theme_stylebox("pressed")
@onready var normal_style: StyleBox = boton_origen.get_theme_stylebox("normal")

signal elegir_estacion_mapa

var en_estacion: bool = false
# 0 = Base, 1 = Origen, 2 = Destino
var modo_seleccion: int = 0
var ID_estacion: int = 1

# Key: Nombre Value: Index
var index_estaciones: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_establecer_flecha(selector_origen.get_selected_id(), 1)
	_establecer_flecha(selector_destino.get_selected_id(), 2)
	
	for controlador: Control in controladores_lineaA:
		controlador.mouse_entered.connect(_on_mouse_entered)
		controlador.mouse_exited.connect(_on_mouse_exited)
		controlador.obtener_estacion.connect(_get_station_name)

	
	for controlador: Control in controladores_lineaB:
		controlador.mouse_entered.connect(_on_mouse_entered)
		controlador.mouse_exited.connect(_on_mouse_exited)
		controlador.obtener_estacion.connect(_get_station_name)
		
	for controlador: Control in controladores_lineaC:
		controlador.mouse_entered.connect(_on_mouse_entered)
		controlador.mouse_exited.connect(_on_mouse_exited)
		controlador.obtener_estacion.connect(_get_station_name)
		
	for controlador: Control in controladores_lineaD:
		controlador.mouse_entered.connect(_on_mouse_entered)
		controlador.mouse_exited.connect(_on_mouse_exited)
		controlador.obtener_estacion.connect(_get_station_name)

		
	for controlador: Control in controladores_lineaE:
		controlador.mouse_entered.connect(_on_mouse_entered)
		controlador.mouse_exited.connect(_on_mouse_exited)
		controlador.obtener_estacion.connect(_get_station_name)
	
	_generate_index_dictionary()

func _on_lista_estaciones_origen_item_selected(index: int) -> void:
	var id = selector_origen.get_selected_id()
	_establecer_flecha(id, 1)


func _on_lista_estaciones_destino_item_selected(index: int) -> void:
	var id = selector_destino.get_selected_id()
	_establecer_flecha(id, 2)

func _establecer_flecha(id: int, tipo: int) -> void:
	print(id)
	var nodo_estacion: Node2D = get_node_mapa(id)
	print(nodo_estacion.name, nodo_estacion.global_position)
	
	var estacion_x = nodo_estacion.global_position.x
	var estacion_y = nodo_estacion.global_position.y
	
	match tipo:
		1:
			flecha_origen.global_position.x = estacion_x
			flecha_origen.global_position.y = estacion_y
		2:
			flecha_destino.global_position.x = estacion_x
			flecha_destino.global_position.y = estacion_y

func get_node_mapa(id: int) -> Node2D:
	var linea: Node2D = get_linea(id)
	
	var nodo_estaciones: Node2D = linea.get_child(0)
	var nodo_estacion: Node2D
	
	var lista_estaciones: Array = nodo_estaciones.get_children()
	for estacion in lista_estaciones:
		if str(id) == estacion.name:
			nodo_estacion = estacion
			break
	
	return nodo_estacion
	

func get_linea(id: int) -> Node2D:
	var num_linea = floor(id / 10)
	var linea: Node2D = mapa.get_child(num_linea)
	return linea

func _on_mouse_entered():
	en_estacion = true

func _on_mouse_exited():
	en_estacion = false
	


func _input(event: InputEvent) -> void:
	if en_estacion and modo_seleccion > 0:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				print(ID_estacion)
				var index = index_estaciones[ID_estacion]
				
				var id = selector_origen.get_item_id(index)
				match modo_seleccion:
					1:
						selector_origen.select(index)
						_establecer_flecha(id, 1)
					2:
						selector_destino.select(index)
						_establecer_flecha(id, 2)
				elegir_estacion_mapa.emit()


func _on_boton_origen_pressed() -> void:
	if modo_seleccion != 1:
		modo_seleccion = 1
	else:
		modo_seleccion = 0 
	
	_change_button_style()
	
func _on_boton_destino_pressed() -> void:
	if modo_seleccion != 2:
		modo_seleccion = 2
	else:
		modo_seleccion = 0
	
	_change_button_style()



func _change_button_style() -> void:
	match modo_seleccion:
		1:
			boton_destino.add_theme_stylebox_override("normal", normal_style)
			boton_origen.add_theme_stylebox_override("normal", pressed_style)
		2:
			boton_origen.add_theme_stylebox_override("normal", normal_style)
			boton_destino.add_theme_stylebox_override("normal", pressed_style)
		_:
			boton_origen.add_theme_stylebox_override("normal", normal_style)
			boton_destino.add_theme_stylebox_override("normal", normal_style)
		pass

func _get_station_name(id) -> void:
	ID_estacion = int(id)
	print(ID_estacion)

func _generate_index_dictionary() -> void:
	for i in range(selector_origen.item_count):
		var id = selector_origen.get_item_id(i)
		if !selector_origen.is_item_disabled(i):
			index_estaciones[id] = i
	
	print(index_estaciones)
	
