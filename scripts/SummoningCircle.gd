extends Node3D
class_name SummoningCircle

@export var spin_speed = 1
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("appear")

func disappear():
	await get_tree().create_timer(0.5).timeout
	anim.play("appear", -1, -1, true)
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta):
	rotate(Vector3.UP, spin_speed * delta)
