extends Control
class_name RoundTimer

@onready var label = $Text
@onready var anim = $Text/AnimationPlayer

@onready var sigil = $TextureRect
var rot_speed = 0.2

@onready var bonus_scene = preload("res://scenes/bonus_time.tscn")
@export var good_color: Color
@export var bad_color : Color 

func show_bonus(time: float):
	var bonus = bonus_scene.instantiate()
	add_child(bonus)
	
	var color = good_color
	var prefix = "+"
	if time < 0:
		color = bad_color
		prefix = ""
	
	bonus.text = prefix + get_str(time)
	bonus.label_settings.font_color = color
	bonus.get_node("AnimationPlayer").play("fade")

func get_str(time: float):
	time = ceili(time)
	return str(time) + "s"

func update(time: float):
	var new_text = get_str(time)
	if label.text != new_text:
		label.text = new_text
		anim.play("bounce")

func _process(delta):
	sigil.rotation += delta * rot_speed
