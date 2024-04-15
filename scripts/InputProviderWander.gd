extends InputProvider
class_name InputProviderWander

@export var wander_range: Vector2
@export var still_range: Vector2

var wandering: bool = false
var time_left: float = 0.0

var wander_dir: float = 0.0

var rng: RandomNumberGenerator

func _init():
	rng = RandomNumberGenerator.new()
	
func init():
	time_left = rng.randf_range(0, still_range.y)

func stop_wander():
	wandering = false
	time_left = rng.randf_range(still_range.x, still_range.y)

func start_wander():
	wandering = true
	wander_dir = rng.randf_range(-PI, PI)
	time_left = rng.randf_range(wander_range.x, wander_range.y)

func get_input(delta: float) -> Vector2:
	time_left = max(0, time_left - delta)
	
	if time_left == 0:
		if !wandering:
			start_wander()
		else:
			stop_wander()
		
	if wandering:
		return Vector2.from_angle(wander_dir)
	else:
		return Vector2.ZERO 
