extends SpawnShape
class_name SpawnShapePlus

@export var rows: int = 5
@export var cols: int = 5

@export var width: float = 5
@export var height: float = 5

func get_points() -> Array:
	var arr = []
	
	for y in rows:
		for x in rows:
			if (x < cols && y < cols):
				continue
			var vec2 = Vector2(x - (cols - 1) / 2.0, y - (rows - 1) / 2.0)
			vec2.x *= width / 2.0
			vec2.y *= height / 2.0
			arr.append(vec2)
			
			if x < cols - rows || x + cols - rows > cols:
				var second = Vector2(vec2.y, vec2.x)
				arr.append(second)
			
			
	#for y in rows:
		#for x in cols:
			#var vec2 = Vector2(x - (cols - 1) / 2.0, y - (rows - 1) / 2.0)
			#vec2.x *= width / 2.0
			#vec2.y *= height / 2.0
			#arr.append(vec2)
			#
			#if x < cols - rows || x + cols - rows > cols:
				#var second = Vector2(vec2.y, vec2.x)
				#arr.append(second)
	
	##for y in cols:
		##for x in rows:
			##var vec2 = Vector2(x - (cols - 1) / 2.0, y - (rows - 1) / 2.0)
			##vec2.x *= height / 2.0
			#vec2.y *= width / 2.0
			#arr.append(vec2)
	
	arr.shuffle()
	return arr
