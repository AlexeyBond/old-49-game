extends Spatial


var state = 'idle'


export var color: Color setget set_color, get_color

func set_color(c):
	var box = $KinematicBody/CSGBox
	if not box: return
	box.material.albedo_color = c
	
func get_color():
	return $KinematicBody/CSGBox.material_override.albedo_color


func on_done_moving():
	if state == 'moving':
		start_idle()

func start_idle():
	state = 'idle'
	$AnimationPlayer.play("idle")

	if not $KinematicBody.test_move($KinematicBody.transform, Vector3(0, -2, 0)):
		state = 'falling'
		$AnimationPlayer.play("fall")
		get_tree().call_group('light_manager', 'force_on')
		return

func try_move(dir: Vector3):
	if $KinematicBody.test_move($KinematicBody.transform, dir):
		return
	
	state = 'moving'
	
	var current_pos = $KinematicBody.translation;
	var next_pos = current_pos + dir * 2.0;
	
	$Tween.interpolate_property(
		$KinematicBody, "translation",
		current_pos,
		next_pos,
		0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	);
	$Tween.interpolate_property(
		$camera_wrapper, "translation",
		current_pos,
		next_pos,
		0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,
		0.125
	);
	$Tween.interpolate_callback(self, 1.0, 'on_done_moving');
	$Tween.interpolate_property(
		$KinematicBody/CSGBox, "scale",
		Vector3.ONE, Vector3.ONE + dir.abs(),
		0.25, Tween.TRANS_LINEAR, Tween.EASE_IN,
		0
	);
	$Tween.interpolate_property(
		$KinematicBody/CSGBox, "scale",
		Vector3.ONE + dir.abs(), Vector3.ONE,
		0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT,
		0.25
	);
	$Tween.start();

const LEFT = Vector3(1,0,0);
const RIGHT = -LEFT;
const FRONT = Vector3(0,0,1);
const BACK = -FRONT;

func _ready():
	$AnimationPlayer.play("idle")

func _process(delta):
	if state == 'idle':
		if Input.is_action_pressed("ui_right"):
			try_move(RIGHT);
		elif Input.is_action_pressed("ui_left"):
			try_move(LEFT);
		elif Input.is_action_pressed("ui_up"):
			try_move(FRONT);
		elif Input.is_action_pressed("ui_down"):
			try_move(BACK);

func on_restart():
	$KinematicBody.translation = Vector3.ZERO
	$camera_wrapper.translation = Vector3.ZERO
	get_tree().call_group('light_manager', 'force_on')

func request_next_level():
	pass

func on_hit_laser():
	if state != 'idle' and state != 'moving':
		return
		
	state = 'exploding'
	
	$AnimationPlayer.play("explode")

func on_win():
	state = 'winning'
	$AnimationPlayer.play("win")
	get_tree().call_group('light_manager', 'force_on')

func on_switch():
	get_tree().call_group('light_manager', 'toggle')
