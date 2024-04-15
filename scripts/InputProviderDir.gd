extends InputProvider
class_name InputProviderDir

@export var redirect_time: float = 5.0
@export var redirect_range: float = 0.0

var angle: float = 0.0

var time_left: float = 0.0


func init():
	angle = PI/2 * randi_range(0, 3)
	time_left = randf_range(0, redirect_time)
	redirect()

func redirect():
	angle += randf_range(-redirect_range, redirect_range)
	
func get_input(delta: float) -> Vector2:
	time_left = max(0, time_left - delta)
	
	if time_left == 0:
		redirect()
		time_left = redirect_time
		
	return Vector2.from_angle(angle)
