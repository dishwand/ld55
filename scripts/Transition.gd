extends TextureRect
class_name Transition

@onready var anim: AnimationPlayer = $AnimationPlayer

func transition():
	anim.play("transition")

func pause():
	anim.pause()

func resume():
	anim.play()

func transition_first():
	anim.play("transition")
	anim.seek(0.25, true)
