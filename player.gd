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

var next_move = null

func start_idle():
	state = 'idle'
	$AnimationPlayer.play("idle")

	if not $KinematicBody.test_move($KinematicBody.transform, Vector3(0, -2, 0)):
		state = 'falling'
		$AnimationPlayer.play("fall")
		get_tree().call_group('light_manager', 'force_on')
		return
		
	if next_move:
		try_move(next_move)
		next_move = null

signal on_move();

func try_move(dir: Vector3):
	if $KinematicBody.test_move($KinematicBody.transform, dir):
		return
	
	emit_signal("on_move")

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
	$Tween.interpolate_callback(self, 0.5, 'on_done_moving');
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

func may_be_try_move(dir):
	if state == 'idle':
		try_move(dir);
	else:
		next_move = dir

const LEFT = Vector3(1,0,0);
const RIGHT = -LEFT;
const FRONT = Vector3(0,0,1);
const BACK = -FRONT;

func _ready():
	$AnimationPlayer.play("idle")

func _process(delta):
	var m = 'is_action_just_pressed'
	if state == 'idle':
		m = 'is_action_pressed'
	
	if Input.call(m, "ui_right"):
		may_be_try_move(RIGHT);
	elif Input.call(m, "ui_left"):
		may_be_try_move(LEFT);
	elif Input.call(m, "ui_up"):
		may_be_try_move(FRONT);
	elif Input.call(m, "ui_down"):
		may_be_try_move(BACK);

func on_restart():
	$KinematicBody.translation = Vector3.ZERO
	$camera_wrapper.translation = Vector3.ZERO
	next_move = null
	get_tree().call_group('light_manager', 'force_on')

func request_next_level():
	get_tree().call_group('level_manager', 'next_level')

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


func _on_swiped(gesture):
	var d = BACK.rotated(Vector3(0,1,0), gesture.get_direction_index() * 3.14 / 4.0);
	
	may_be_try_move(d)
