extends Area2D

var speed = 700
var direction = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position = global_position + velocity

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name or "enemy2" in body.name or body.is_in_group("enemy"):
		if body.has_method("recibir_danio"):
			body.recibir_danio(15) 
		elif body.has_method("kill"):
			body.kill()
		queue_free()
	else:
		if body.name != "player" and not body.is_in_group("player"):
			queue_free()
