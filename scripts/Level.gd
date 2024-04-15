extends Resource
class_name Level

@export var goal_count: int = 1

var rng: RandomNumberGenerator = null

@export var goal_schema: ImpSchema = null

@export var show_profile: bool = true

@export var reason: String = ""
@export var imp_name: String = ""
@export var imp_description: String = ""

@export var layout: LevelLayout

@export var env: Env = Env.Airport

@export var dark: bool = false

@export var override_move_speed: float = -1.0

enum Env {
	Airport,
	Tunnel,
	Tunnel2,
	City,
	Office
}

var schemas = []

func _init():
	rng = RandomNumberGenerator.new()

func init_level():
	schemas = []
	for i in layout.num_imps:
		schemas.append(next_schema())
	
	goal_schema.is_target = true
	# Regardless, schemas[0] contains the target
	if goal_schema is ImpSchemaGetter:
		var target_idx = goal_schema.get_from_imps(schemas)
		var target_schema = schemas[target_idx]
		target_schema.is_target = true
		schemas.remove_at(target_idx)
		schemas.insert(0, target_schema)
		goal_schema.set_schema(target_schema)
	else:
		schemas[0] = goal_schema

func get_reason():
	return reason

func get_imp_name():
	return imp_name
	
func get_description():
	return imp_description

func next_schema() -> ImpSchema:
	var is_unique = false
	
	var schema = null
	while !is_unique:
		schema = ImpSchema.new()
		schema.color = rng.randi_range(0, 32)
		schema.eye = rng.randi_range(0, 6)
		schema.mesh_var = rng.randi_range(0, 4)
		schema.horn_var = rng.randi_range(0, 3)
		
		is_unique = check_unique(schema)
	return schema

func check_unique(schema: ImpSchema):
	for s in schemas:
		if s.equals(schema):
			return false
	return true

func check_selection(selections):
	if selections.size() != goal_count:
		return false
	for i in selections:
		if not i.schema.is_target:
			return false
	return true
