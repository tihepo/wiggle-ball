extends Node3D

signal hit
signal missed

func _on_plane_body_entered(body):
	$Cylinder.set_deferred("monitoring", false)
	$Plane.set_deferred("monitoring", false)
	missed.emit()

func _on_cylinder_body_entered(body):
	$Cylinder.set_deferred("monitoring", false)
	$Plane.set_deferred("monitoring", false)
	hit.emit()
