extends Area2D

var speed = 2000
var direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position = global_position + velocity

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name or body.is_in_group("enemy"):
		if body.has_method("recibir_danio"):
			body.recibir_danio(10) # Hace daño numérico al enemigo en vez de borrarlo directo
		elif body.has_method("kill"):
			body.kill()
		queue_free()
	else:
		if body.name != "player" and not body.is_in_group("player"):
			queue_free()
