extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var enabled = get_tree().get_nodes_in_group('light_manager')[0].laser_state;
	
	if not enabled:
		$CPUParticles.emitting = false
		$CSGCylinder.visible = false
		return
	else:
		$CSGCylinder.visible = true

	var cp = $RayCast.get_collision_point()
	if not $RayCast.is_colliding():
		cp = $RayCast.global_transform * Vector3(0, 100, 0)
	var dst = (cp - global_transform.origin).length()
	
	$CSGCylinder.scale = Vector3(1, dst, 1)
	$CSGCylinder.translation = Vector3(dst * 0.5, 0, 0)
	
	$CPUParticles.emitting = $RayCast.is_colliding()
	$CPUParticles.global_transform.origin = cp
	
	if $RayCast.is_colliding():
		var p = $RayCast.get_collider().get_parent()
		if p.has_method('on_hit_laser'):
			p.on_hit_laser()
