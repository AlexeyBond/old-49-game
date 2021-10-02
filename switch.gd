extends Spatial

func _on_Area_body_entered(body):
	var p = body.get_parent()
	
	if p.has_method('on_switch'):
		p.on_switch()
