extends KinematicBody

#beginning work on gravity
const GRAVITY = Vector3(0,10,0)
const MASS = 1
var VELOCITY = Vector3()
var is_on_floor = false

export var speed = 10
export var mouse_sens = 0.5
export var jump_speed = 10

onready var camera = $Camera

func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
#this rotates the camera on mouse movement. Relative x and y above
	#if event.is_action_pressed("jump") and is_on_floor:
		#VELOCITY.y = jump_speed
		#is_on_floor = false

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _physics_process(delta):
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction += -transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction += -transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	direction = direction.normalized()
	direction *= speed
	move_and_slide(direction)
	# apply gravity
	VELOCITY -= GRAVITY * delta
	VELOCITY = move_and_slide(VELOCITY, Vector3.UP)
	move_and_slide(direction + VELOCITY)
	var snap = Vector3(0, -1, 0) # snap to the floor
	var floor_normal = Vector3()
	var is_on_floor_new = move_and_slide(VELOCITY + snap, Vector3(0, 1, 0), false, 4, 0.785398, true)

