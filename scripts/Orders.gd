extends Control
class_name Orders

@onready var label = $Label

var inf_mode: bool = false

func show_orders():
	visible = true

func hide_orders():
	visible = false

func update(num: int):
	if inf_mode:
		label.text = "Score: " + str(num)
	else:
		label.text = str(num) + " Remaining"
	
