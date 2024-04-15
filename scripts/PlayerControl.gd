extends Node3D
class_name PlayerController

@export_flags_3d_physics var collision_mask = null
@export var panel: Control = null
@export var game: GameController = null

@export var hover_audio: AudioStream
@export var select_audios: Array[AudioStream]

var hovered_imp = null

var selection_count = 3
var selections = []

var controlling: bool = false

func deselect_all():
	for s in selections:
		s.set_selected(false)
	
	#hovered_imp = null
	selections = []

func on_hovered(new_hover):
	if new_hover == null:
		if hovered_imp and is_instance_valid(hovered_imp):
			hovered_imp.set_hover(false)
		hovered_imp = null
		return
	
	if hovered_imp != null:
		if hovered_imp == new_hover:
			return
		hovered_imp.set_hover(false)
	hovered_imp = new_hover
	hovered_imp.set_hover(true)
	AudioMan.play_sound(hover_audio, -5)

func select():
	if hovered_imp == null || selections.size() == selection_count:
		return
	
	var selected = hovered_imp.selected
	if hovered_imp.selected:
		selections.erase(hovered_imp)
	else:
		AudioMan.play_sound(select_audios[min(selections.size(), select_audios.size() - 1)], -8)
		selections.append(hovered_imp)
	
	hovered_imp.set_selected(!selected)
	
	if selections.size() == selection_count:
		await get_tree().create_timer(0.1).timeout
		game.check()

func _unhandled_input(event):
	if not controlling:
		return
	if event.is_action_pressed("select_mouse"):
		select()

func _process(delta):
	if not controlling:
		return

	var mouse_position = get_viewport().get_mouse_position()
	mouse_position.x -= panel.get_rect().size.x/2
	var camera = get_viewport().get_camera_3d()
	var ray_from = camera.project_ray_origin(mouse_position)
	var ray_to = ray_from + camera.project_ray_normal(mouse_position) * 10000

	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.new()
	ray.from = ray_from
	ray.to = ray_to
	ray.collision_mask = collision_mask
	#ray.exclude = [get_rid()]
	var result = space_state.intersect_ray(ray)
	if result:
		var object = result["collider"]
		if object is Imp:
			on_hovered(object)
	else:
		on_hovered(null)
