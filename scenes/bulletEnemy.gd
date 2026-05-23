extends Area2D

var speed = 400
var direction = Vector2.RIGHT
var shooter = null

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position = global_position + velocity

func _on_body_entered(body: Node2D):
	
	if not shooter or not is_instance_valid(shooter):
		queue_free()
		return
	
	if body == shooter:
		return
		
	if shooter.name == "Player" and body.is_in_group("enemy"):
		body.recibir_danio(15)
		queue_free()
		return
	
	queue_free()
