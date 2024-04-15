extends InputProvider
class_name InputProviderSpin

var spin_speed = 0.5
var angle: float = 0.0

func init():
	angle = randf_range(-PI, PI)
	if randi_range(0, 1) == 0:
		spin_speed *= -1

func get_input(delta: float) -> Vector2:
	angle += spin_speed * delta
	return Vector2.from_angle(angle)
