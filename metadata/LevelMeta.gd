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
	return get_parent().get_child(get_index() + 1)
