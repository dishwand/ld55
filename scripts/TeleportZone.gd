extends Area3D
class_name TeleportZone

@export var target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	if target == null:
		target = $Target
	
func on_body_entered(body: Node):
	if body is Imp:
		body.global_position = target.global_position
		
