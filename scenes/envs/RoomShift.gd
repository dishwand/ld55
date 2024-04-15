extends Node3D

var cam = null
@export var cam_pos: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2.0).timeout
	var tween = create_tween()
	tween.tween_method(update_pos, -60.645, 0.0, 22.0)
	
	cam = get_parent().get_parent().get_parent().get_node("Camera3D")

func update_pos(val):
	if cam:
		cam_pos.position.x = val
		cam.global_position = cam_pos.global_position
