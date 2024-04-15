extends Control
class_name ActIntro
@export var clack_sound: AudioStream
@export var game_controller: GameController

var acts = ["I", "II", "III", "IV", "V", "VI", "VII", "???"]

var desc_idx: int = 0
var showing_desc: bool = false
var desc_timer: float = 0.0

var act: Act = null

var timeout: bool = false


func act_show(_act: Act, act_num: int):
	$Title.visible = false
	$Subtitle.visible = false
	$Description.visible = false
	modulate = Color.WHITE
	act = _act
	$Title.text = "Act " + str(acts[min(act_num, acts.size() - 1)])
	$Subtitle.text = act.act_title
	$Description.text = ""
	
	desc_idx = -3
	showing_desc = true
	progress_desc()


func progress_desc():
	if not showing_desc:
		return
	desc_idx += 1
	desc_timer = 0.0
	
	if desc_idx == -2:
		$Title.visible = true
		AudioMan.play_sound(clack_sound)
		return
	elif desc_idx == -1:
		AudioMan.play_sound(clack_sound)
		$Subtitle.visible = true
		return
	
	if desc_idx == act.act_description.size():
		showing_desc = false
		game_controller.on_act_intro_done()
	else:
		$Description.visible = true
		AudioMan.play_sound(clack_sound)
		$Description.text += "[p]" + act.act_description[desc_idx] + "[/p][p] [/p]"
	

func show_timeout():
	$Title.visible = false
	$Subtitle.visible = false
	$Description.visible = false
	modulate = Color.WHITE
	timeout = true
	$Timeout.visible = true

func _process(delta: float):
	if showing_desc:
		desc_timer += delta
		
		if desc_timer >= 2.5:
			progress_desc()

func _unhandled_input(event):
	if event.is_action_pressed("select_mouse"):
		if timeout:
			timeout = false
			$Timeout.visible = false
			game_controller.on_timeout_done()
		else:
			progress_desc()

func act_hide():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	#$Title.visible = false
	#$Subtitle.visible = false
	#$Description.visible = false
