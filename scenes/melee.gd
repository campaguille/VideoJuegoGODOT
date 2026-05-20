extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D

func _ready() -> void:
	anim.play("slash")
	audio.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		body.kill()
		queue_free()
	else:
		if body.name != "player":
			queue_free()
