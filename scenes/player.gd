extends CharacterBody2D

@export var speed = 400
var bullet = preload("res://bullet.tscn")
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	direction = Input.get_axis("move_up", "move_down")
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	look_at(get_global_mouse_position())
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		fire()
	
	
func fire():
	var offset = 30
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position + Vector2.RIGHT.rotated(rotation) * offset
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.direction = Vector2.RIGHT.rotated(rotation)
	get_tree().get_root().add_child(bullet_instance)

func kill():
	get_tree().reload_current_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		kill()
