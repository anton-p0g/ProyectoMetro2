extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var estaciones_origen = $listaEstaciones

	# Verifica que el nodo existe
	if estaciones_origen:
		estaciones_origen.add_item("Línea A")
		estaciones_origen.set_item_disabled(estaciones_origen.get_item_count() - 1, true)
		estaciones_origen.add_item("Plaza de Mayo", 11)
		estaciones_origen.add_item("Perú", 12)
		estaciones_origen.add_item("Piedras", 13)
		estaciones_origen.add_item("Lima", 14)
		estaciones_origen.add_item("Saenz Peña", 15)
		estaciones_origen.add_item("Congreso", 16)
		estaciones_origen.add_item("Pasco", 17)
		estaciones_origen.add_item("Alberti", 18)

		estaciones_origen.add_item("Línea B")
		estaciones_origen.set_item_disabled(estaciones_origen.get_item_count() - 1, true)
		estaciones_origen.add_item("Leandro N. Alem", 21)
		estaciones_origen.add_item("Florida", 22)
		estaciones_origen.add_item("Carlos Pellegrini", 23)
		estaciones_origen.add_item("Uruguay", 24)
		estaciones_origen.add_item("Callao", 25)
		estaciones_origen.add_item("Pasteur", 26)

		estaciones_origen.add_item("Línea C")
		estaciones_origen.set_item_disabled(estaciones_origen.get_item_count() - 1, true)
		estaciones_origen.add_item("Constitución", 31)
		estaciones_origen.add_item("San Juan", 32)
		estaciones_origen.add_item("Independencia", 33)
		estaciones_origen.add_item("Moreno", 34)
		estaciones_origen.add_item("Avenida de Mayo", 35)
		estaciones_origen.add_item("Diagonal Norte", 36)
		estaciones_origen.add_item("Lavalle", 37)
		estaciones_origen.add_item("San Martín", 38)
		estaciones_origen.add_item("Retiro", 39)

		estaciones_origen.add_item("Línea D")
		estaciones_origen.set_item_disabled(estaciones_origen.get_item_count() - 1, true)
		estaciones_origen.add_item("Facultad de Medicina", 41)
		estaciones_origen.add_item("Callao", 42)
		estaciones_origen.add_item("Tribunales", 43)
		estaciones_origen.add_item("9 de Julio", 44)
		estaciones_origen.add_item("Catedral", 45)

		estaciones_origen.add_item("Línea E")
		estaciones_origen.set_item_disabled(estaciones_origen.get_item_count() - 1, true)
		estaciones_origen.add_item("Pichincha", 51)
		estaciones_origen.add_item("Entre Ríos", 52)
		estaciones_origen.add_item("San José", 53)
		estaciones_origen.add_item("Independencia", 54)
		estaciones_origen.add_item("Belgrano", 55)
		estaciones_origen.add_item("Bolívar", 56)
	else:
		print("Error: No se encontró el nodo EstacionesOrigen.")
