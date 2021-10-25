class_name Level
extends Spatial

export(String, FILE, "*.tscn,*.scn") var next_level;

signal on_play;

func play():
	emit_signal("on_play")
