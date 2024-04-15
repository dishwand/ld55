extends Resource
class_name RandomLevel

@export var level: Level = null

@export var reasons: Array[String] = []

@export var names: Array[String] = []

@export var descriptions: Array[String] = []

func get_level():
	var new_level = level.duplicate()

	var rand_idx = randi_range(0, reasons.size() - 1)
	
	new_level.reason = reasons[rand_idx]
	new_level.imp_name = names[rand_idx]
	new_level.imp_description = descriptions[rand_idx]
	return new_level
