extends Node

var pools: Dictionary = {}

func play_pooled_sound(resource: PooledAudioResource, volume: float = 0.0):
	if resource == null:
		return
	
	var id = resource.id
	var pool = null
	if id in pools:
		pool = pools[id]
	else:
		pool = Node.new()
		pool.name = resource.id
		add_child(pool)
		pools[id] = pool
	
	var num_sounds = pool.get_child_count()
	if num_sounds >= resource.polyphony:
		return
	
	var sound = _make_sound_pooled(resource.stream, volume)
	pool.add_child(sound)
	if num_sounds > 0:
		await get_tree().create_timer(randf_range(0.0, resource.max_delay)).timeout
	sound.play()

func _make_sound_pooled(stream: AudioStream, volume: float = 0.0):
	return _make_sound(stream, volume)

func play_sound(stream: AudioStream, volume: float = 0.0):
	var instance = _make_sound(stream, volume)
	add_child(instance)
	instance.play()
	

func _make_sound(stream: AudioStream, volume: float):
	if stream == null:
		return
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.volume_db = volume
	instance.finished.connect(remove_node.bind(instance))

	return instance

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
