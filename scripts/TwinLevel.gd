extends Level
class_name TwinLevel

@export var num_copies_of_goal: int = 0

func init_level():
	super()
	
	for i in range(num_copies_of_goal):
		var dupe = schemas[0].duplicate()
		dupe.override_move_speed = schemas[0].override_move_speed
		dupe.is_target = true
		schemas[i + 1] = dupe
		
	#if goal_schema is ImpSchemaGetter:
		#var target = goal_schema.get_from_imps(schemas)
		#goal_schema.set_schema(target)
	#else:
		#schemas[0] = goal_schema
