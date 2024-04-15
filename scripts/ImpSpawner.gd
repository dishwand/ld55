extends Node3D
class_name ImpSpawner

@onready var imp_scene = preload("res://scenes/demon.tscn")

@export var imp_parent: Node3D

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var cur_level: Level = null
var colorblind: bool = false

#func _ready():
	#init_level(cur_level)

func cleanup():
	for n in imp_parent.get_children():
		remove_child(n)
		n.queue_free()

func spawn_level(level: Level):
	var points = level.layout.spawn_shape.get_points()
	for i in range(level.layout.num_imps):
		#var pos = Vector3(rng.randf_range(-10, 10), 0.05, rng.randf_range(-10, 10))
		var shape_pos = points[i]
		var pos = Vector3(shape_pos.x, 0.05, shape_pos.y)
		spawn_imp(pos, level.schemas[i], level)

func spawn_imp(pos: Vector3, schema: ImpSchema, level: Level):
	var new_imp = imp_scene.instantiate()
	imp_parent.add_child(new_imp)
	new_imp.position = pos
	
	if level.override_move_speed >= 0.0:
		new_imp.move_speed = level.override_move_speed
	
	new_imp.set_schema(schema)
	new_imp.set_input_provider(level.layout.imp_input.duplicate())
	if colorblind:
		new_imp.show_colorblind()
	

	
	return new_imp
