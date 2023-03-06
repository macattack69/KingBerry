extends KinematicBody

#beginning work on gravity
const GRAVITY = Vector3(0,10,0)
const MASS = 1
var velocity = Vector3()
var is_on_floor = false
var pressed_jump = false
var body_to_move: KinematicBody = null
var snap_vec: Vector3

signal movement_info

export var speed = 10
export var mouse_sens = 0.5
export var jump_force = 10

onready var camera = $Camera

func init(_body_to_move: KinematicBody):
	body_to_move = _body_to_move

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
	if Input.is_action_just_pressed("jump"):
		jump()
	
	var grounded = body_to_move.is_on_floor()
	if grounded:
		velocity.y = -0.01
	if grounded and pressed_jump:
		velocity.y = jump_force
		snap_vec = Vector3.ZERO
	else:
		snap_vec = Vector3.DOWN
	pressed_jump = false
	emit_signal("movement_info", velocity, grounded)
	
func jump():
	pressed_jump = true
	
	# apply 
	#OLD JUMP CODE
	#VELOCITY -= GRAVITY * delta
	#VELOCITY = move_and_slide(VELOCITY, Vector3.UP)
	#move_and_slide(direction + VELOCITY)
	#var snap = Vector3(0, -1, 0) # snap to the floor
	#var floor_normal = Vector3()
	#var is_on_floor_new = move_and_slide(VELOCITY + snap, Vector3(0, 1, 0), false, 4, 0.785398, true)
	#is_on_floor = is_on_floor_new
