extends TextureRect

@export var game: GameController
var started: bool = false

var last_pressed = 0

func _unhandled_input(event):
	if !started && event.is_action_pressed("select_mouse"):
		var diff = Time.get_ticks_msec() - last_pressed
		
		if diff > 0 && diff < 300:
			started = true
			AudioMan.play_sound(game.paper.slide_sound)
			$AnimationPlayer.play("slide")
			await get_tree().create_timer(1.5).timeout
			game.start_game()
		
		
		last_pressed = Time.get_ticks_msec()
		
		
		
