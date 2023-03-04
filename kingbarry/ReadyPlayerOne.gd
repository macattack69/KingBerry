#ChatGPT Wrote this, so let me add some comments to try to explain it
#these notes are for my benefit, but enjoy them regardless🤠
#Michael
extends KinematicBody
#so this is at the start of all the scripts to show their parent class
#specifying this class provides customizable functionality
#KinematicBody comes barebones from Godot. It only is significant
#because it can listen for input, unlike other bodies, which listen
#to the physics engine for their physics. We have to define the physics for it here,
#and use the input to utilize said physics.

#beginning work on gravity
const GRAVITY = Vector3(0,10,0)
const MASS = 1
var VELOCITY = Vector3()
var is_on_floor = false

export var speed = 10
export var mouse_sens = 0.5
export var jump_speed = 10

onready var camera = get_node("Camera")

func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#this turns listening for input on without this the kinematicBody player wouldnt take input
#this happens when the parent node is first placed in the scene
#hides mouse, locks to application

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
#this rotates the camera on mouse movement. Relative x and y above
	if event.is_action_pressed("jump") and is_on_floor:
		VELOCITY.y = jump_speed
		is_on_floor = false

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
	VELOCITY += GRAVITY * delta
	VELOCITY = move_and_slide(VELOCITY, Vector3.UP)
	move_and_slide(direction + VELOCITY)
	var snap = Vector3(0, -1, 0) # snap to the floor
	var floor_normal = Vector3()
	var is_on_floor_new = move_and_slide(VELOCITY + snap, Vector3(0, 1, 0), false, 4, 0.785398, true)

#this is the big one, like the last function takes mouse input (only movement for now)
#this function takes keyboard input (or gamepad input idk yet)
#this is pretty cool, basically its taking a direction variable,
#its checking to see if the button is pressed
#then its taking that variable, adding a positive or negative value
#it then makes sure that the direction is normalized (more on that later)
#it then uses a combination of the speed variable from earlier, and the built-in
#move_and_slide() function to manipulate the parent nodes movement
#pretttty neaaat right?

#interesting note now that I made the movement function above work
#basically, the "move_..." strings are input mapping actions dictated by
#keys, in that same mentioned input mapping menu under project settings
#thanks debugga! I do not use the hard R



