extends CharacterBody2D

@onready var navigation_agent_2d = $NavigationAgent2D
@export var speed: float = 300.0       

var player

func _ready():
	player = get_parent().get_node("Player")
	
func _physics_process(_delta):
	# 1. Seguridad: Si el jugador no existe, nos detenemos
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		return



	look_at(player.global_position)

	var next_path_pos = navigation_agent_2d.get_next_path_position()
	
	# Restamos la posición del punto menos la nuestra para saber hacia dónde ir
	var direction = (next_path_pos - global_position).normalized()
	
	# 5. Aplicar velocidad y mover
	velocity = direction * speed
	move_and_slide()





func kill():
	queue_free()


func _on_timer_timeout():
	navigation_agent_2d.target_position = player.global_position
