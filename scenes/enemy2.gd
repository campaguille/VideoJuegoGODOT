extends CharacterBody2D

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var ray_cast_2d = $RayCast2D
@onready var timer = $TimerTarget
@onready var anim = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer

@export var speed: float = 200.0
@export var dano: int = 10
@export var vida: int = 30
@export var puntos_al_morir: int = 50
@export var angle: float = 120.0
@export var angle_length: float = 500.0

var direction_angle: Vector2 = Vector2.RIGHT
var player_target: bool = false
var posicion_inicial: Vector2
var player
var angle_rad
var rotacion_inicial
var bullet: Resource = preload("res://scenes/bullet.tscn")


func _ready():
	player = get_parent().get_node("Player")
	angle_rad = deg_to_rad(angle / 2)
	posicion_inicial = global_position
	rotacion_inicial = global_rotation
	add_to_group("enemy")


func _draw():
	var left_dir = direction_angle.rotated(-angle_rad) * angle_length
	var right_dir = direction_angle.rotated(angle_rad) * angle_length
	draw_line(Vector2.ZERO, left_dir, Color.YELLOW, 2)
	draw_line(Vector2.ZERO, right_dir, Color.YELLOW, 2)


func _physics_process(_delta):
	var next_path_pos: Vector2
	var direction: Vector2

	if not player_target:
		if is_in_cone() and is_in_ray():
			player_target = true
			timer.start()
			shoot_timer.start()

			look_at(player.global_position)
			next_path_pos = navigation_agent_2d.get_next_path_position()
			direction = (next_path_pos - global_position).normalized()

			velocity = direction * speed
			move_and_slide()

		else:
			var distancia_a_casa = global_position.distance_to(posicion_inicial)

			if distancia_a_casa > 5.0:
				navigation_agent_2d.target_position = posicion_inicial
				next_path_pos = navigation_agent_2d.get_next_path_position()
				direction = (next_path_pos - global_position).normalized()

				look_at(next_path_pos)
				velocity = direction * speed
				move_and_slide()

			else:
				global_position = posicion_inicial
				velocity = Vector2.ZERO
				global_rotation = rotacion_inicial

	else:
		is_in_cone()
		is_in_ray()
		look_at(player.global_position)

		next_path_pos = navigation_agent_2d.get_next_path_position()
		direction = (next_path_pos - global_position).normalized()

		velocity = direction * speed
		move_and_slide()

	update_animation()


func update_animation():
	if velocity.length() > 10:
		if anim.animation != "default" or not anim.is_playing():
			anim.play("default")
	else:
		if anim.is_playing():
			anim.stop()


func is_in_cone():
	var player_local_position = to_local(player.global_position)
	var angle_to_player = direction_angle.angle_to(player_local_position)
	var distance_player = player_local_position.length()

	return abs(angle_to_player) <= angle_rad and distance_player < angle_length


func is_in_ray() :
	ray_cast_2d.target_position = to_local(player.global_position)
	ray_cast_2d.force_raycast_update()

	var collider = ray_cast_2d.get_collider()
	return collider == player

func recibir_danio(cantidad: int):
	vida -= cantidad
	
	var tween = create_tween()
	modulate = Color.RED 
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if vida <= 0:
		kill()

func kill():
	player.add_score(puntos_al_morir)
	
	remove_from_group("enemy")
	queue_free()
	
	GameManager.verificar_enemigos_vivos()


func _on_timer_timeout():
	if is_instance_valid(player):
		navigation_agent_2d.target_position = player.global_position


func _on_timer_target_timeout():
	player_target = false
	shoot_timer.stop()
	
func shoot():
	
	if not is_instance_valid(player):
		return
	var bullet_instance = bullet.instantiate()
		
	var offset = 40
	
	bullet_instance.shooter = self
	bullet_instance.position = global_position + Vector2.RIGHT.rotated(rotation)
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.direction = Vector2.RIGHT.rotated(rotation)
	


	
	get_tree().current_scene.add_child(bullet_instance)
	


func _on_shoot_timer_timeout() -> void:
	if player_target and is_in_ray():
		shoot()
