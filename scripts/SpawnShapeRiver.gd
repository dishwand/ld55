extends SpawnShape
class_name SpawnShapeRiver

@export var num_per_river: int = 10

var width = 14.0
var height = 31.0

func get_points() -> Array:
	var arr = []
	var cols = num_per_river
	var rows = 3
	for y in range(3):
		for x in range(num_per_river):
			var vec2 = Vector2(x - (cols - 1) / 2.0, y - (rows - 1) / 2.0)
			vec2.x *= width / 2.0
			vec2.y *= height / 2.0
			vec2.y -= 6.0
			arr.append(vec2)
	arr.shuffle()
	return arr
