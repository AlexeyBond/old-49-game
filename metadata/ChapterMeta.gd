class_name ChapterMeta
extends Node

export(String) var title;
export(Texture) var icon_image;
export(bool) var is_wip = false;

func get_id():
	var parent = get_parent()

	if parent.has_method('get_id'):
		return parent.get_id() + '/' + name
	
	return name

func get_levels():
	var levels = []
	for child in get_children():
		if child is LevelMeta:
			levels.append(child)
	
	return levels