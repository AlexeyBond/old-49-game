extends Spatial

export(String, FILE, "*.tscn,*.scn") var first_level;

var level_node;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	level_node = load(first_level).instance();
	add_child(level_node)
	add_to_group('level_manager')

func change_level(level):
	remove_child(level_node);
	level_node = load(level).instance()
	add_child(level_node)

func next_level():
	var nl = level_node.next_level;
	if not nl: nl = first_level;
	change_level(nl)

func restart():
	$player.on_restart()
	change_level(first_level);

func _process(delta):
	if Input.is_action_just_released("restart"):
		restart()
