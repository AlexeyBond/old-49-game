extends Spatial

export(String, FILE, "*.tscn,*.scn") var first_level;

var level_node;

func _ready():
	level_node = load(first_level).instance();
	add_child(level_node)
	add_to_group('level_manager')

func next_level():
	var nl = level_node.next_level;
	if not nl: nl = first_level;
	remove_child(level_node);
	level_node = load(nl).instance()
	add_child(level_node)
