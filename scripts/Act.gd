extends Resource
class_name Act

@export var levels: Array[Level] = []

@export var rand_templates: Array[RandomLevel] = []

@export var num_rand_levels: int = 10

@export var act_title: String = ""
@export var act_description: Array[String] = []

@export var music: AudioStream = null

func get_level(i: int):
	if i < levels.size():
		return levels[i]
	
	return get_rand_level()
	
func get_rand_level() -> Level:
	var new_level = rand_templates.pick_random().get_level()
	
	return new_level	
