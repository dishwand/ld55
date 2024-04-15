extends RigidBody3D
class_name Imp

@onready var model = $Armature
@onready var skel = $Armature/Skeleton3D
@onready var char = $Armature/Skeleton3D/Char
@onready var horns = $Armature/Skeleton3D/BoneAttachment3D/Horns
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")

@export var move_speed = 5.5
@export var accel_factor = 5.0
@export var accel_from_dot: Curve
@export var max_accel_force = 10.0
@export var max_accel_from_dot: Curve

@export var rotation_speed = 30

var input: Vector2 = Vector2.ZERO
var input_dir_angle: float = 0.0
var goal_vel: Vector3 = Vector3.ZERO

var schema: ImpSchema = null

var selected: bool = false
var hovered: bool = false

var is_hover_vis: bool = false

@export var can_move: bool = true
var sinking: bool = false

var circle: SummoningCircle = null
@onready var summoning_scene = preload("res://scenes/summoning_circle.tscn")

@export var sink_curve: Curve = null

@export var input_provider: InputProvider = null

# ummm bad
@onready var meshes = [
	preload("res://models/imp/imp1.res"),
	preload("res://models/imp/imp2/imp2.res"),
	preload("res://models/imp/imp2/imp3.res"),
	preload("res://models/imp/imp2/imp4.res"),
	preload("res://models/imp/imp2/imp5.res")
]

@onready var horn_meshes = [
	preload("res://models/imp/horns/horn1.res"),
	preload("res://models/imp/horns/horn2.res"),
	preload("res://models/imp/horns/horn3.res"),
]

var in_water: bool = false
var water_push: Vector3 = Vector3.ZERO
var water_time: float = 0.0

func _ready():
	water_time = randf_range(-5, 0)

func enter_water(water: WaterZone):
	#if in_water:
		#return
	in_water = true
	water_push = water.push_dir
	
func set_input_provider(provider):
	if input_provider != null:
		return
	input_provider = provider
	input_provider.imp = self
	input_provider.init()

func set_schema(_schema: ImpSchema):
	schema = _schema
	model = $Armature
	char = $Armature/Skeleton3D/Char
	anim_tree = $AnimationTree
	anim_state = $AnimationTree.get("parameters/playback")
	if schema.override_move_speed >= 0.0:
		move_speed = schema.override_move_speed
	set_visuals()
	
	if schema.input_provider != null:
		set_input_provider(schema.input_provider)

func show_circle():
	if circle != null:
		return
	
	get_tree().create_timer(0.1).timeout.connect(func():
		circle = summoning_scene.instantiate()
		add_child(circle)
	)
	

func do_huh():
	can_move = false
	anim_state.travel("huh")
	get_tree().create_timer(1.0).timeout.connect(func():
		can_move = true	
	)

func do_sink():
	sinking = true
	$CollisionShape3D.disabled = true
	axis_lock_linear_x = true
	axis_lock_linear_y = true
	axis_lock_linear_z = true
	can_move = false
	anim_state.travel("sink")
	var tween = create_tween()
	tween.tween_method(sink_callback, 0.0, 1.0, 0.8)

func sink_callback(frac: float):
	$Armature.position = Vector3(0, sink_curve.sample(frac) * -10, 0)

func hide_circle():
	if circle == null:
		return
	circle.disappear()
	circle = null

func set_visuals():
	set_color()
	set_eye()
	set_mesh()

func set_mesh():
	char.mesh = meshes[schema.mesh_var]
	
	if schema.horn_var == 0:
		horns.visible = false
	else:
		horns.visible = true
		horns.mesh = horn_meshes[schema.horn_var - 1]

func set_color():
	var color_idx = schema.color
	$Armature/Skeleton3D/BoneAttachment3D/Access.text = str(color_idx)
	var rows = 4
	var cols = 8
	var x = color_idx % cols
	var y = color_idx / cols
	var x_offset = (1.0 / cols) * x
	var y_offset = (1.0 / rows) * y
	char.get_surface_override_material(0).uv1_offset = Vector3(x_offset, y_offset, 0)

func set_eye():
	var eye_idk = schema.eye
	var rows = 4
	var cols = 4
	var x = eye_idk % cols
	var y = eye_idk / cols
	var x_offset = (1.0 / cols) * x
	var y_offset = (1.0 / rows) * y
	char.get_surface_override_material(1).uv1_offset = Vector3(x_offset, y_offset, 0)

func update_hover_vis():
	var new_hover_vis = hovered || selected
	if new_hover_vis == is_hover_vis:
		return
	
	is_hover_vis = new_hover_vis
	
	if is_hover_vis:
		#char.sorting_offset = 1000000000000
		char.set_layer_mask_value(3, true)
		horns.set_layer_mask_value(3, true)
		
		#char.set_layer_mask_value(1, false)
		
		var tween = create_tween()
		tween.tween_property(skel, "scale", Vector3(1.2, 1.2, 1.2), 0.1)
		var tween2 = create_tween()
		tween2.tween_property(skel, "position", Vector3(0, 0.2, 0), 0.1)
		

		#char.scale = Vector3(1.2, 1.2, 1.2)
		char.get_surface_override_material(0).next_pass.set_shader_parameter("color", Color.WHITE)
		char.get_surface_override_material(2).next_pass.set_shader_parameter("color", Color.WHITE)
		#char.get_surface_override_material(1).no_depth_test = true
		#char.get_surface_override_material(2).no_depth_test = true
	else:
		#char.sorting_offset = 0
		#char.position = Vector3(0, 0.0, 0)
		char.set_layer_mask_value(3, false)
		horns.set_layer_mask_value(3, false)
		#char.set_layer_mask_value(1, true)
		#char.scale = Vector3.ONE
		var tween = create_tween()
		tween.tween_property(skel, "scale", Vector3.ONE, 0.1)
		var tween2 = create_tween()
		tween2.tween_property(skel, "position", Vector3.ZERO, 0.1)
		char.get_surface_override_material(0).next_pass.set_shader_parameter("color", Color.BLACK)
		char.get_surface_override_material(2).next_pass.set_shader_parameter("color", Color.BLACK)
		#char.get_surface_override_material(0).no_depth_test = false
		#char.get_surface_override_material(1).no_depth_test = false
		#char.get_surface_override_material(2).no_depth_test = false

func set_selected(val: bool):
	if selected == val:
		return
	selected = val
	
	if not selected:
		hovered = false
		update_hover_vis()
		hide_circle()
	else:
		update_hover_vis()
		show_circle()
	

func set_hover(val: bool):
	hovered = val
	update_hover_vis()

func damp(a, b, lambda, delta):
	return a.lerp(b, 1 - exp(-lambda * delta))

func damp_angle(a, b, lambda, delta):
	return lerp_angle(a, b, 1 - exp(-lambda * delta))
	
func get_vel_dot_cur_input():
	return get_vel_dot_input(input)

func get_vel_dot_input(_input: Vector2):
	var unit_goal3 = Vector3(_input.x, 0.0, _input.y)

	var unit_vel = goal_vel.normalized()
	var vel_dot = unit_goal3.dot(unit_vel)
	# vel_dot goes from -1 to 1, adjust for curve sampling:
	vel_dot = 0.5 + (vel_dot / 2.0)
	return vel_dot
	
func move_dir(_input: Vector2, delta: float, accel_k: float = 1.0):
	# the first argument input is the unit goal velocity
	var unit_goal3 = Vector3(_input.x, 0.0, _input.y)
	
	
	
	var vel_dot = get_vel_dot_input(_input)
	
	var new_goal_vel = unit_goal3 * move_speed
	
	if in_water:
		new_goal_vel = water_push
	
	var accel_value = accel_factor * accel_from_dot.sample(vel_dot)
	accel_value *= accel_k
	
	goal_vel = goal_vel.move_toward(new_goal_vel, accel_value * delta)
	
	var needed_accel = (goal_vel - linear_velocity) / delta
	needed_accel.y = 0
	var max_accel_value = max_accel_force * max_accel_from_dot.sample(vel_dot)
	
	
	#speed_damped = damp_float(speed_damped, linear_velocity.length() / move_speed, speed_damp_factor * pow(max_accel_from_dot.sample(vel_dot), 0.5), delta)
	
	if needed_accel.length() > max_accel_value:
		needed_accel = max_accel_value * needed_accel.normalized()
	
	#acceleration += needed_accel
	apply_central_force(needed_accel)
	
func get_velocity_dir(input) -> Vector3:
	return Vector3(input.x, 0, input.y).rotated(Vector3.UP, 0)

func get_input(delta):
	if not can_move or input_provider == null:
		input = Vector2.ZERO
	elif input_provider != null:
		input = input_provider.get_input(delta)
		#input = Input.get_vector("left", "right", "front", "back")
	var dir = get_velocity_dir(input)
	input_dir_angle = atan2(-input.y, input.x) + PI / 2

func update_anim(delta):
	var speed = linear_velocity.length() / move_speed
	if in_water:
		speed = 0.0
	anim_tree.set("parameters/BlendTree/IWR/blend_position", speed)
	var run_factor = 1.0
	anim_tree.set("parameters/BlendTree/TimeScale/scale", clamp(run_factor * speed, 1, 3))

func rotate_towards_input(delta: float, rot_speed: float):
	if input.length() >= 0.02:
		model.rotation.y = damp_angle(model.rotation.y, input_dir_angle, rot_speed, delta)

func do_water_anim(delta):
	if in_water and anim_state.get_current_node() == "BlendTree":
		water_time += delta * 5
		skel.position.y = 0.5 * sin(water_time)

func show_colorblind():
		$Armature/Skeleton3D/BoneAttachment3D/Access.visible = true

func _physics_process(delta):
	get_input(delta)
	move_dir(input.normalized(), delta, accel_factor)
	update_anim(delta)
	do_water_anim(delta)
	rotate_towards_input(delta, rotation_speed)
