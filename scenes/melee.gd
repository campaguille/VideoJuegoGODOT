extends Area2D

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("slash")
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") or "enemy" in body.name or "enemy2" in body.name:
		if body.has_method("recibir_danio"):
			body.recibir_danio(30) # El ataque melee ahora hace 30 de daño (puedes cambiarlo)
		elif body.has_method("kill"):
			body.kill()
		queue_free()
	else:
		if body.name != "player" and not body.is_in_group("player"):
			queue_free()
