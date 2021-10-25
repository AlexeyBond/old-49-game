class_name LevelMeta
extends Node

export(String, FILE, "*.tscn,*.scn") var level_scene;
export(String) var title;
export(int) var max_skipped_before = 2;

func get_id():
	return get_parent().get_id() + '/' + name

func get_chapter():
	return get_parent()

func get_next():
	var index = get_index()
	if index == get_parent().get_child_count() - 1:
		return null
	return get_parent().get_child(index + 1)
