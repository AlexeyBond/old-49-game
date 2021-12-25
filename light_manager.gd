extends Node

var target_state = true
export var light_state: bool setget set_light_state, get_light_state;
export var laser_state = true
export var laser_blue_state = false

var env_dark = preload("res://env_dark.tres")
var env_default = preload("res://env_default.tres")

func set_light_state(ls):
	var ps = light_state
	light_state = ls
	if not is_inside_tree():
		return
	#if not $WorldEnvironment or not $DirectionalLight:
	#	return
	if ps != ls:
		if ls:
			$WorldEnvironment.environment = env_default
			$DirectionalLight.visible = true
		else:
			$WorldEnvironment.environment = env_dark
			$DirectionalLight.visible = false

func get_light_state():
	return light_state

func toggle():
	target_state = not target_state
	if target_state:
		$AnimationPlayer.play("on")
	else:
		$AnimationPlayer.play("off")

func force_on():
	target_state = true
	$AnimationPlayer.play("force_on")

func on_level_restarted():
	force_on()

func _ready():
	add_to_group('light_manager')
	add_to_group('restart_observer')
	force_on()

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit(0)
