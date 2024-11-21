import networkx as nx
from math import radians, sin, cos, sqrt, atan2
import json
import sys
from datetime import datetime, timedelta



dict_estaciones = {
				   11: {"name": "Plaza de Mayo", "coordenadas": (-34.6088103091689, -58.3709684989674), "tiempo": 1},
				   12: {"name": "Perú", "coordenadas": (-34.6085590738532, -58.3742677264304), "tiempo": 1},
				   13: {"name": "Piedras", "coordenadas": (-34.608881721215, -58.3790851530908), "tiempo": 2},
				   14: {"name": "Lima", "coordenadas": (-34.6090998065519, -58.3822324010181), "tiempo": 1},
				   15: {"name": "Saenz Peña", "coordenadas": (-34.6094125865027, -58.3867771940873), "tiempo": 1},
				   16: {"name": "Congreso", "coordenadas": (-34.6092256843174, -58.3926688246648), "tiempo": 1},
				   17: {"name": "Pasco", "coordenadas": (-34.6096459617052, -58.3984269918123), "tiempo": 1},
				   18: {"name": "Alberti", "coordenadas": (-34.6098335784398, -58.401207534233), "tiempo": 0},
				   21: {"name": "Leandro N. Alem", "coordenadas": (-34.6029894966332, -58.369929850122300), "tiempo": 1},
				   22: {"name": "Florida", "coordenadas": (-34.603297285577500, -58.375071518263500), "tiempo": 1},
				   23: {"name": "Carlos Pellegrini", "coordenadas": (-34.6036371051817, -58.380714847140800), "tiempo": 1},
				   24: {"name": "Uruguay", "coordenadas": (-34.6040935531057, -58.387296133540700), "tiempo": 2},
				   25: {"name": "CallaoB", "coordenadas": (-34.604419542860700, -58.392314235088700), "tiempo": 1},
				   26: {"name": "Pasteur", "coordenadas": (-34.604642967919300, -58.399474256679), "tiempo": 0},
				   31: {"name": "Constitución", "coordenadas": (-34.6276194522548, -58.381434433934295), "tiempo": 1},
				   32: {"name": "San Juan", "coordenadas": (-34.6219167322081, -58.3799211788651), "tiempo": 2},
				   33: {"name": "IndependenciaC", "coordenadas": (-34.6181255992933, -58.380173610475204), "tiempo": 2},
				   34: {"name": "Moreno", "coordenadas": (-34.6126172798037, -58.38044446966), "tiempo": 1},
				   35: {"name": "Avenida de Mayo", "coordenadas": (-34.6089833148827, -58.3806107179579), "tiempo": 2},
				   36: {"name": "Diagonal Norte", "coordenadas": (-34.604843739913996, -58.3795299800739), "tiempo": 1},
				   37: {"name": "Lavalle", "coordenadas": (-34.601769923011396, -58.3781557828244), "tiempo": 2},
				   38: {"name": "San Martín", "coordenadas": (-34.5950574047792, -58.3778190509867), "tiempo": 1},
				   39: {"name": "Retiro", "coordenadas": (-34.5911938083332, -58.3740182164816), "tiempo": 0},
				   41: {"name": "Facultad de Medicina", "coordenadas": (-34.5997570807639, -58.3979237555734), "tiempo": 1},
				   42: {"name": "CallaoD", "coordenadas": (-34.604419542860700, -58.392314235088700), "tiempo": 2},
				   43: {"name": "Tribunales", "coordenadas": (-34.6015871651394, -58.385142358801200), "tiempo": 1},
				   44: {"name": "9 de Julio", "coordenadas": (-34.6042452029629, -58.3805743428896), "tiempo": 2},
				   45: {"name": "Catedral", "coordenadas": (-34.6078023364289, -58.3739558069511), "tiempo": 0},
				   51: {"name": "Pichincha", "coordenadas": (-34.62310987, -58.39706807), "tiempo": 1},
				   52: {"name": "Entre Ríos", "coordenadas": (-34.62271967, -58.3915116999715), "tiempo": 2},
				   53: {"name": "San José", "coordenadas": (-34.62233949, -58.38514855), "tiempo": 1},
				   54: {"name": "IndependenciaE", "coordenadas": (-34.61793739, -58.38153494), "tiempo": 2},
				   55: {"name": "Belgrano", "coordenadas": (-34.61284911, -58.37758089), "tiempo": 1},
				   56: {"name": "Bolívar", "coordenadas": (-34.60924243, -58.37368422), "tiempo": 0}
	}

def add_metro_network(graph):
	lineas_metro_ids = [
		list(range(11, 19)),  # Línea A
		list(range(21, 27)),  # Línea B
		list(range(31, 40)),  # Línea C
		list(range(41, 46)),  # Línea D
		list(range(51, 57)),  # Línea E
	]

	for linea in lineas_metro_ids:
		for i in range(len(linea) - 1):
			graph.add_edge(linea[i], linea[i+1], weight = dict_estaciones[linea[i]]["tiempo"])

	# Correspondencias (peso de 5 min)
	graph.add_edge(44, 23, weight=5)
	graph.add_edge(44, 36, weight=5)
	graph.add_edge(14, 35, weight=5)
	graph.add_edge(12, 45, weight=5)
	graph.add_edge(12, 56, weight=5)
	graph.add_edge(33, 54, weight=5)
	graph.add_edge(45, 56, weight=5)


def find_station_id_by_name(station_name):
	for station_id, station_info in dict_estaciones.items():
		if station_info["name"] == station_name:
			return station_id
	raise ValueError(f"Estación '{station_name}' no encontrada en el diccionario.")


def heuristic_metro_stations(current, destination, velocidad_media = 0.8333333333333334):
	def tiempo_haversine(lat1, lon1, lat2, lon2):
		"""
		Calcula el tiempo estimado de viaje entre dos puntos geográficos usando la fórmula de Haversine.
		Parameters:
		lat1, lon1: Coordenadas (latitud y longitud) del punto inicial en grados.
		lat2, lon2: Coordenadas (latitud y longitud) del punto final en grados.
		velocidad_media: Velocidad media en kilómetros por minuto.
		Returns:
		float: Tiempo estimado en minutos entre los dos puntos.
		"""
		# Radio de la Tierra en kilómetros
		r = 6371.0

		# Convertir coordenadas de grados a radianes
		lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])

		# Aplicar la fórmula de Haversine para calcular la distancia
		dlat = lat2 - lat1
		dlon = lon2 - lon1
		a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
		c = 2 * atan2(sqrt(a), sqrt(1 - a))
		distancia = r * c  # distancia en kilómetros

		# Retorna el tiempo estimado dividiendo la distancia por la velocidad media
		return distancia / velocidad_media

	if current == destination:
		return 0

	coords_current = dict_estaciones[current]["coordenadas"]
	coords_destination = dict_estaciones[destination]["coordenadas"]

	return tiempo_haversine(coords_current[0], coords_current[1], coords_destination[0], coords_destination[1])


def main():

	if len(sys.argv) != 6:
		print(f"Number of arguments passed: {len(sys.argv)} - expected 6 arguments.")
		sys.exit(1)

	source_id = int(sys.argv[1])
	target_id = int(sys.argv[2])
	day = int(sys.argv[3])
	hour = int(sys.argv[4])
	minute = int(sys.argv[5])

	metro = nx.Graph()
	add_metro_network(metro)

	path_ids = nx.astar_path(metro, source_id, target_id, heuristic_metro_stations, weight="weight")
	travel_duration_minutes = nx.astar_path_length(metro, source_id, target_id, heuristic_metro_stations)

	path_nombres = []
	for elem in path_ids:
		path_nombres.append(dict_estaciones[elem]["name"])

	current_time = datetime(year=2024, month=1, day=1, hour=hour, minute=minute)
	travel_duration = timedelta(minutes=travel_duration_minutes)
	arrival_time = current_time + travel_duration

	output = {
		"estaciones_path": path_nombres,
		"path_ids": path_ids,
		"travel_duration": travel_duration_minutes,
		"arrival_time": arrival_time.strftime("%H:%M")
	}
	print(json.dumps(output))


if __name__ == "__main__":
	main()
