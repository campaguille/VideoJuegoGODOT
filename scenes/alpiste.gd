extends Area2D

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player" and body.has_method("curar"):
		
		if  body.vida_actual < body.vida_maxima:
			body.curar(35)
			queue_free()
