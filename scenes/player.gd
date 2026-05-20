extends CharacterBody2D

@export var speed: float = 400.0
@export var dash_distance: float = 400.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 0.6
@export var vida_maxima: int = 100

var vida_actual: int = 100
var can_dash: bool = true
var puntos: int = 0
var invulnerable: bool = false
var tween_parpadeo: Tween = null  # FIX: referencia al tween para poder cancelarlo

var dashing: bool = false
var dash_dir: Vector2 = Vector2.ZERO
var dash_elapsed: float = 0.0
var dash_max_spd: float = 0.0

var bullet: Resource = preload("res://scenes/bullet.tscn")
var melee: Resource  = preload("res://scenes/melee.tscn")

@onready var anim      = $AnimatedSprite2D
@onready var area      = $Area2D
@onready var hud       = get_tree().get_root().get_node("GameScene/HUD")
@onready var sfx_click = $sfxDisparo
@onready var sfx_melee = $sfxMelee

func _ready():
	add_to_group("player")
	vida_actual = vida_maxima
	hud.update_vida(vida_actual, vida_maxima)

func _physics_process(delta):
	if dashing:
		_process_dash(delta)
		return

	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if input_dir != Vector2.ZERO:
		anim.play("default")
		velocity = input_dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.y = move_toward(velocity.y, 0.0, speed)
		anim.stop()

	look_at(get_global_mouse_position())
	move_and_slide()

	if Input.is_action_just_pressed("attack"): _fire()
	if Input.is_action_just_pressed("melee"):  _melee()
	if Input.is_action_just_pressed("dash") and can_dash:
		var dir = input_dir if input_dir != Vector2.ZERO else Vector2.RIGHT.rotated(rotation)
		_dash(dir)

func _fire():
	var b = bullet.instantiate()
	b.global_position = global_position + Vector2.RIGHT.rotated(rotation) * 40.0
	b.global_rotation  = rotation
	b.direction        = Vector2.RIGHT.rotated(rotation)
	get_parent().add_child(b)
	if sfx_click: sfx_click.play()

func _melee():
	var m = melee.instantiate()
	m.position = Vector2.RIGHT * 55.0
	add_child(m)
	if sfx_melee: sfx_melee.play()

func _dash(dir: Vector2):
	can_dash        = false
	dashing         = true
	dash_dir        = dir
	dash_elapsed    = 0.0
	dash_max_spd    = dash_distance / dash_duration
	area.monitoring = false
	set_collision_mask_value(3, false)

func _process_dash(delta):
	dash_elapsed += delta
	if dash_elapsed < dash_duration:
		velocity = dash_dir * dash_max_spd * (1.0 - dash_elapsed / dash_duration)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		dashing  = false
		set_collision_mask_value(3, true)
		area.monitoring = true
		get_tree().create_timer(dash_cooldown).timeout.connect(func(): can_dash = true)

func recibir_danio(cantidad: int):
	if invulnerable: return
	vida_actual = clamp(vida_actual - cantidad, 0, vida_maxima)
	hud.update_vida(vida_actual, vida_maxima)
	if vida_actual <= 0:
		morir()
		return
	_iniciar_parpadeo()

func _iniciar_parpadeo():
	# FIX: cancela el tween anterior si existe antes de crear uno nuevo
	if tween_parpadeo != null and tween_parpadeo.is_running():
		tween_parpadeo.kill()
		modulate.a = 1.0  # resetea alpha por si quedó a medias

	invulnerable = true
	tween_parpadeo = create_tween()
	tween_parpadeo.set_loops(6)
	tween_parpadeo.tween_property(self, "modulate:a", 0.2, 0.08)
	tween_parpadeo.tween_property(self, "modulate:a", 1.0, 0.08)

	# FIX: usamos finished del tween en vez de await para no bloquear
	tween_parpadeo.finished.connect(_fin_parpadeo, CONNECT_ONE_SHOT)

func _fin_parpadeo():
	modulate.a  = 1.0   # FIX: garantiza alpha completo al terminar
	invulnerable = false
	tween_parpadeo = null

func add_score(valor: int):
	puntos += valor
	hud.update_score(puntos)

func morir():
	# FIX: limpia el tween y el alpha antes de cambiar de escena
	if tween_parpadeo != null and tween_parpadeo.is_running():
		tween_parpadeo.kill()
	modulate.a = 1.0
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
