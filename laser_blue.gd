class_name BlueLaser
extends RedLaser

func is_enabled():
	return not get_tree().get_nodes_in_group('light_manager')[0].laser_state
