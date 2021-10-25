extends Spatial

var level_node = null;

var chapter_progress;

var level_meta;
var level_progress;
var level_completed_before;

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	add_to_group('level_manager')
	$Timer.start()

func change_level(level):
	if level_node:
		remove_child(level_node)
		
		if true: # TODO: Do iff completed
			level_progress.mark_completed()
		level_progress.write()
	level_node = load(level.level_scene).instance()
	add_child(level_node)
	level_meta = level
	level_progress = chapter_progress.get_level_progress(level)
	level_completed_before = level_progress.is_completed()
	
	if not level_completed_before:
		level_progress.add_attempt()
		level_progress.write()
	
	level_node.play()
	
	$Timer.stop()
	$Timer.start()

func next_level():
	var next = level_meta.get_next()
	
	while next:
		var progress = chapter_progress.get_level_progress(next)
		
		if not progress.is_completed():
			change_level(next)
			return

		next = next.get_next()
	
	for level in level_meta.get_chapter().get_levels():
		if level == level_meta:
			break

		var progress = chapter_progress.get_level_progress(level)
	
		if not progress.is_completed():
			change_level(level)
			return
	
	chapter_completed()

func chapter_completed():
	pass


func _on_player_on_move():
	if not level_completed_before:
		level_progress.add_move()

func _on_Timer_timeout():
	if not level_completed_before:
		level_progress.track_spent_time($Timer.wait_time)
		level_progress.write()

func to_chapter_menu():
	level_progress.write()
	
	var chapter_menu_scene = load("res://ui/menu.tscn")
	
	var menu = chapter_menu_scene.instance()
	menu.chapter = level_meta.get_chapter()
	menu.chapter_progress = chapter_progress
	
	queue_free()
	get_parent().add_child(menu)

func _on_close_button_pressed():
	to_chapter_menu()
