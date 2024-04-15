extends AudioStreamPlayer
class_name Music

var wait_time: float = 0.0

func play_audio(_stream: AudioStream):
	wait_time = 0.0
	if playing:
		var tween = create_tween()
		tween.tween_property(self, "volume_db", -20, 1.0)
		await get_tree().create_timer(1.1).timeout
		
	stream = _stream
	play()
	finished.connect(on_finished)

func on_finished():
	wait_time = randf_range(10.0, 20.0)

func _process(delta):
	if wait_time > 0:
		wait_time -= delta
		if wait_time <= 0:
			play()
	
	
