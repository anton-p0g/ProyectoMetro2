extends Control

@onready var estacion_origen = $SeleccionarRuta/Origen/listaEstaciones
@onready var estacion_destino = $SeleccionarRuta/Destino/listaEstaciones
@onready var boton_calcular = $CalcularRuta
@onready var aviso = $AvisoMismasEstaciones
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	check(estacion_origen, estacion_destino)

func _on_lista_estaciones_item_selected(index: int) -> void:
	check(estacion_origen, estacion_destino)

func check(origen: OptionButton, destino: OptionButton) -> void:
	if origen.get_selected() == destino.get_selected():
		boton_calcular.mouse_default_cursor_shape = CURSOR_FORBIDDEN
		boton_calcular.disabled = true
		aviso.visible = true
	else:
		boton_calcular.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		boton_calcular.disabled = false
		aviso.visible = false
	
