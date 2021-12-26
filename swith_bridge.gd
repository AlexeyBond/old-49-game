extends Spatial

var state = false

func _ready():
	reset_state()
	add_to_group('restart_observer')

func reset_state():
	state = false
	var items_count = 0

	for child_ in get_children():
		var child: Node = child_
		if not child.name.begins_with('item'):
			continue
	
		var node: Spatial = child.get_node('object')
		var target_node: Spatial = child.get_node('target')

		if not node or not target_node:
			print_debug('Child ' + child.name + ' does not have "object" or "target" node:')
			child.print_tree_pretty()
			continue
		
		node.global_transform = child.global_transform
		items_count += 1
	
	if items_count == 0:
		print_debug('Switch bridge ' + get_path() + ' has no item nodes')

func on_level_restarted():
	reset_state()

func move_items(target_state):
	var tween = $Tween

	for child_ in get_children():
		var child: Node = child_
		if not child.name.begins_with('item'):
			continue
		
		var node: Spatial = child.get_node('object')
		var target_transform
		if not target_state:
			target_transform = (child as Spatial).global_transform
		else:
			target_transform = (child.get_node('target') as Spatial).global_transform
		
		tween.interpolate_property(
			node,
			'global_transform',
			node.global_transform,
			target_transform,
			0.5,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT,
			0.5
		);

	tween.start();

func _on_Area_body_entered(_body):
	state = not state
	move_items(state)
