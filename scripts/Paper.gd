extends TextureRect
class_name Paper

var rand_rot: float = 4

var rand_x: float = 10
var rand_y: float = 6

var slide_duration = 1.0
var discard_duration = 1.0

var top_y:float = -1000.0
var left_x : float = -500.0

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var target_y: float = 0
var target_x: float = 0

@export var curve: Curve
@export var discard_curve: Curve

@export var profile_demon: Imp = null

@onready var tween: Tween = null

@export var slide_sound: AudioStream = null


func _init():
	rng = RandomNumberGenerator.new()

func update_from_level(level: Level):
	$Reason.text = level.get_reason().to_upper()
	$Name.text = level.get_imp_name().to_upper()
	$RichTextLabel.text = level.get_description()
	
	if level.show_profile:
		$PortraitViewport.visible = true
		$MissingPic.visible = false
		profile_demon.set_schema(level.goal_schema)
	else:
		$PortraitViewport.visible = false
		$MissingPic.visible = true

func do_discard():
	if tween:
		tween.kill()
	tween = create_tween()	
	tween.tween_method(set_discard, 0.0, 1.0, discard_duration)
	
func set_discard(frac: float):
	position.x = lerp(target_x, left_x, discard_curve.sample(frac))

func do_slide():
	AudioMan.play_sound(slide_sound)
	
	target_x = rng.randf_range(-rand_x, rand_x)
	position = Vector2(target_x, top_y)
	target_y = rng.randf_range(-rand_y, rand_y)
	rotation = deg_to_rad(rng.randf_range(-rand_rot, rand_rot))

	if tween:
		tween.kill()
	tween = create_tween()	
	tween.tween_method(set_slide, 0.0, 1.0, slide_duration)

func set_slide(frac: float):
	position.y = lerp(top_y, target_y, curve.sample(frac))

#func _unhandled_input(event):
	#if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		#do_slide()
	#if event is InputEventKey and event.pressed and event.keycode == KEY_W:
		#do_discard()
