extends Area2D

var speed = 2000
var direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position = global_position + velocity


func _on_body_entered(body: Node2D) -> void:
	if body.name == "enemy":
		body.kill()
		queue_free()
	else:
		if body.name != "player":
			queue_free()
