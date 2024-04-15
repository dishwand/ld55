extends ImpSchemaGetter
class_name ImpSchemaRandom2

func get_from_imps(imps):
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(0, imps.size() - 1)
