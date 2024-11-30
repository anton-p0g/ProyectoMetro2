extends Node

func get_python_path() -> String:
	var command = "where" if OS.get_name() == "Windows" else "which"
	var result = []
	var res = OS.execute(command, ["python"], result, true)
	
	var regex = RegEx.new()
	regex.compile("\\S+")
	var results = Array()
	for element in regex.search_all(result[0]):
		results.append(element.get_string())
	
	if res == 0 and result.size() > 0:
		return results[0].strip_edges()
	else:
		print("Error: Unable to find Python executable.")
		return ""

	
func run_python_script(source_id, target_id, day, hour, minute):
	var python_path = get_python_path()
	if python_path == "":
		return

	var output = []
	var python_file = ProjectSettings.globalize_path("res://Scripts/backend.py")
	var result = OS.execute(python_path, [python_file, str(source_id), str(target_id), str(day), str(hour), str(minute)], output, true, false)
	
	if result == 0:
		var parsedOutput = JSON.parse_string(output[0])
		
		GlobalData.path = parsedOutput["estaciones_path"]
		print(GlobalData.path)
		GlobalData.travel_duration = parsedOutput["travel_duration"]
		print(GlobalData.travel_duration)
		GlobalData.path_ids = parsedOutput["path_ids"]
		print(GlobalData.path_ids)
		GlobalData.arrival_time = parsedOutput["arrival_time"]
		print(GlobalData.arrival_time)
		GlobalData.grouped_path = parsedOutput["grouped_path"]
		print(GlobalData.grouped_path)
		GlobalData.transfers = parsedOutput["transfers"]
		print(GlobalData.transfers)
		
	else:
		print("Error running Python script:", result)
