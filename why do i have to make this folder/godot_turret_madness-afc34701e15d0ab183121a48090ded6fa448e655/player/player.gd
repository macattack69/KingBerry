extends KinematicBody2D

signal health_change
signal death

export var velocity = Vector2()
export var max_health = 3
export(int) var health = max_health

func _ready():
	position = Vector2(
		get_viewport_rect().size.x * 0.5,
		get_viewport_rect().size.y * 0.5
	)
	
# signal update health	
func on_hit():
	print("ouch")
	health -= 1
	if 0 < health:
		emit_signal("health_change")
	else:
		emit_signal("death")
		queue_free()

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("up"):
		velocity = Vector2(160, 0).rotated(rotation)
	if Input.is_action_pressed("down"):
		velocity = Vector2(-80, 0).rotated(rotation)
	if Input.is_action_pressed("left"):
		velocity = Vector2(0, -60).rotated(rotation)
	if Input.is_action_pressed("right"):
		velocity = Vector2(0, 60).rotated(rotation)
		
	position += velocity * delta
