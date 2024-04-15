extends Resource
class_name ImpSchema


@export var color: int = 0
@export var eye: int = 0
@export var mesh_var: int = 0
@export var horn_var: int = 0

@export var input_provider: InputProvider = null

var is_target: bool = false

var override_move_speed: float = -1.0

func equals(other: ImpSchema):
	return other.color == color && other.eye == eye && other.mesh_var == mesh_var && other.horn_var == horn_var
