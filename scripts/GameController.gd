extends Node3D
class_name GameController

@export var timer: RoundTimer = null
@export var orders: Orders = null
@export var player: PlayerController = null
@export var imp_spawner: ImpSpawner = null
@export var paper: Paper = null
@export var transition: Transition = null
@export var flashlight: Flashlight = null

@export var cur_level: Level = null
var cur_act: Act = null
@export var acts: Array[Act]
var cur_act_num = -1

@export var act_intro: ActIntro = null

@export var next_level_audio: AudioStream
@export var timeout_audio: AudioStream
@export var wrong_audio: AudioStream

var level_num: int = 0

var time: float = 0.0
var playing: bool = false

@export var env_parent: Node3D
@export var env_scenes: Array[PackedScene] = []
@export var cam: Camera3D
var cur_env: Level.Env = Level.Env.Tunnel
var has_cur_env: bool = false

@export var music: Music
@export var title_music: AudioStream = null

var handicap: int = 0
@export var colorblind_btn: CheckButton

var inf_mode: bool = false

func _ready():
	music.play_audio(title_music)
	pass
	#start_game()
	
func start_game():
	var cb = colorblind_btn.button_pressed
	imp_spawner.colorblind = cb
	if cb:
		paper.profile_demon.show_colorblind()
	progress_act()
	music.play_audio(cur_act.music)
	act_intro.act_show(cur_act, cur_act_num)

func progress_act():
	cur_act_num += 1
	cur_act = acts[cur_act_num]
	
	if not inf_mode and cur_act_num == 4:
		inf_mode = true
		orders.inf_mode = true
		for i in range(acts.size() - 1):
			for t in acts[i].rand_templates:
				cur_act.rand_templates.append(t)
		
		#cur_act.rand_templates

func on_act_intro_done():
	act_intro.act_hide()
	transition.transition_first()
	await get_tree().create_timer(0.4).timeout
	start_round()
	
func start_round():
	level_num = 0
	timer.visible = true
	orders.show_orders()
	time = 120
	playing = true
	
	start_level(cur_act.get_level(level_num))

func check_env():
	var new_env = cur_level.env
	if !has_cur_env || new_env != cur_env:
		has_cur_env = true
		if env_parent.get_child_count() > 0:
			var child = env_parent.get_child(0)
			env_parent.remove_child(child)
			child.queue_free()
		var scene = env_scenes[new_env]
		var new_scene = scene.instantiate()
		env_parent.add_child(new_scene)
		cur_env = new_env
		cam.global_position = new_scene.get_node("CameraPos").global_position
		cam.rotation = new_scene.get_node("CameraPos").rotation

func start_level(level: Level):
	cur_level = level
	check_env()
	flashlight.visible = level.dark
	level.init_level()
	imp_spawner.spawn_level(level)
	
	paper.update_from_level(level)
	paper.do_slide()
	
	if inf_mode:
		orders.update(level_num )
	else:
		orders.update(cur_act.levels.size() + cur_act.num_rand_levels - level_num)
	
	player.controlling = true
	player.selection_count = level.goal_count

func cleanup_level():
	imp_spawner.cleanup()

func act_over():
	return !inf_mode && level_num >= -1 + cur_act.levels.size() + cur_act.num_rand_levels

func next_level():
	player.controlling = false
	paper.do_discard()
	for i in player.selections:
		i.do_sink()
	
	await get_tree().create_timer(1.0).timeout
	transition.transition()
	await get_tree().create_timer(0.25).timeout
	
	cleanup_level()

	if act_over():
		handicap = 0
		transition.pause()
		timer.visible = false
		orders.hide_orders()
		progress_act()
		music.play_audio(cur_act.music)
		act_intro.act_show(cur_act, cur_act_num)
	else:
		await get_tree().create_timer(0.15).timeout
		
		level_num += 1
		start_level(cur_act.get_level(level_num))
	
func check():
	if cur_level.check_selection(player.selections):
		AudioMan.play_sound(next_level_audio)
		add_time_bonus(6 + handicap)
		next_level()
	else:
		for i in player.selections:
			i.do_huh()
		AudioMan.play_sound(wrong_audio)
		add_time_bonus(-3)
	
	player.deselect_all()

func add_time_bonus(bonus: float):
	if time + bonus <= 0:
		return
	
	time = clamp(time + bonus, 0, 999)

	timer.show_bonus(bonus)

func time_over():
	playing = false
	handicap += 2
	AudioMan.play_sound(timeout_audio, -15)
	player.controlling = false
	paper.do_discard()
	
	transition.transition()
	await get_tree().create_timer(0.25).timeout
	
	cleanup_level()

	transition.pause()
	timer.visible = false
	orders.hide_orders()
	cur_act_num -= 1
	progress_act()
	act_intro.show_timeout()

func on_timeout_done():
	music.play_audio(cur_act.music)
	act_intro.act_show(cur_act, cur_act_num)

func check_game_over():
	if time == 0:
		time_over()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:
		AudioMan.play_sound(next_level_audio)
		add_time_bonus(6 + handicap)
		next_level()
		player.deselect_all()

func _process(delta):
	
	if not playing:
		return
	
	time = max(0, time - delta)
	
	timer.update(time)
	
	check_game_over()
