extends Area2D

var speed = 2000
var direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position = global_position + velocity

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		if body.has_method("recibir_danio"):
			body.recibir_danio(15) 
		elif body.has_method("kill"):
			body.kill()
		queue_free()
