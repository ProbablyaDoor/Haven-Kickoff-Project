extends Node2D

@export var speed: float = 50.0
@export var dash_cooldown: float = 0.0
var target: Node2D = null
var cooldown_timer = 0.0

@export var attack_range = 25

@export var attack_cooldown = 0.5

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent().get_node_or_null("Player")
	timer.timeout.connect(_on_timer_timeout)

func is_player_in_range():
	return (target.position - position).length() <= attack_range



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dash_cooldown += 0.1
	if dash_cooldown >= 50.0:
		speed = 250
		timer.start()
		dash_cooldown = 0.0


	if target == null:
		return
	
	global_position = global_position.move_toward(target.global_position, speed * delta)
	cooldown_timer += delta
	if cooldown_timer >= attack_cooldown:
		cooldown_timer = 0
		if is_player_in_range():
			get_tree().reload_current_scene()
	
	if target.global_position.x < global_position.x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
		
func _on_timer_timeout():
	speed = 50
