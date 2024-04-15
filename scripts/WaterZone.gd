extends Area3D
class_name WaterZone

@export var push_dir: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node):
	if body is Imp:
		body.enter_water(self)
		
