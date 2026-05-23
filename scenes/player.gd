extends CharacterBody2D

@export var speed: float = 500.0
@export var dash_distance: float  = 400.0
@export var dash_duration: float  = 0.1
@export var dash_cooldown: float  = 0.6
@export var vida_maxima: int = 100

var vida_actual: int = 100
var current_dash_speed: float = 0.0
var bullet : Resource = preload("res://scenes/bullet.tscn")
var melee : Resource = preload("res://scenes/melee.tscn")
var screen_size
var can_dash = true
var puntos: int = 0
var vidas: int = 0

var invulnerable: bool = false
var tween_parpadeo: Tween = null
var posicion_inicial_nivel: Vector2 = Vector2.ZERO

@onready var anim = $AnimatedSprite2D
@onready var hud = get_tree().get_root().get_node("GameScene/HUD")  #referencia al CanvasLayer

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if input_dir != Vector2.ZERO:
		if anim.animation != "default" or not anim.is_playing():
			anim.play("default")
			
		velocity = input_dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		if anim.is_playing():
			anim.stop()

	look_at(get_global_mouse_position())
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		fire()
	
	if Input.is_action_just_pressed("melee"):
		var offset = 50
		var melee_instance : Area2D = melee.instantiate()
		melee_instance.position = Vector2.RIGHT * offset
		melee_instance.rotation = 0
		add_child(melee_instance)

	if Input.is_action_just_pressed("dash") and can_dash:
		var dash_dir = input_dir if input_dir != Vector2.ZERO else Vector2.RIGHT.rotated(rotation)
		dash(dash_dir)

func fire():
	var offset = 30
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position + Vector2.RIGHT.rotated(rotation) * offset
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.direction = Vector2.RIGHT.rotated(rotation)
	get_tree().get_root().add_child(bullet_instance)

func dash(target_direction: Vector2):
	if not can_dash:
		return

	can_dash = false
	$Area2D.monitoring = false
	set_collision_mask_value(3, false)

	var max_dash_speed = (dash_distance / dash_duration) * 1.5
	current_dash_speed = max_dash_speed

	var tween = create_tween()
	tween.tween_property(self, "current_dash_speed", 0.0, dash_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	var dash_timer = get_tree().create_timer(dash_duration)
	while dash_timer.time_left > 0:
		velocity = target_direction * current_dash_speed
		move_and_slide()
		await get_tree().physics_frame

	current_dash_speed = 0.0
	set_collision_mask_value(3, true)
	$Area2D.monitoring = true

	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true


func recibir_danio(cantidad: int):
	if invulnerable: 
		return
		
	vida_actual = clamp(vida_actual - cantidad, 0, vida_maxima)
	if hud and hud.has_method("update_vida"):
		hud.update_vida(vida_actual, vida_maxima)
	
	if vida_actual <= 0:
		kill()
		return
		
	_iniciar_parpadeo()

func kill():
	
	GameManager.puntos_finales = puntos
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")





func _iniciar_parpadeo():
	if tween_parpadeo != null and tween_parpadeo.is_running():
		tween_parpadeo.kill()
		modulate.a = 1.0

	invulnerable = true
	tween_parpadeo = create_tween()
	tween_parpadeo.set_loops(6)
	tween_parpadeo.tween_property(self, "modulate:a", 0.2, 0.08)
	tween_parpadeo.tween_property(self, "modulate:a", 1.0, 0.08)

	tween_parpadeo.finished.connect(_fin_parpadeo, CONNECT_ONE_SHOT)

func _fin_parpadeo():
	modulate.a = 1.0   
	invulnerable = false
	tween_parpadeo = null
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		if "dano" in body:
			recibir_danio(body.dano)
func add_score(points: int):
	puntos += points
	hud.update_score(puntos)
