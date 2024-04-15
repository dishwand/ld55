extends ImpSchemaGetter
class_name ImpSchemaRandomFast

@export var set_move_speed: float = -1.0

func get_from_imps(imps):
	var rng = RandomNumberGenerator.new()
	var idx = rng.randi_range(0, imps.size() - 1)
	imps[idx].override_move_speed = set_move_speed
	return idx
