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

export var speed = 10
#clearly this goes brrrrrr
#its our only variable for now, and like most languages variables
#are preferrably specified before functions because multiple functions
#typically call the same variables and you might get some undefined errors if
#you structured it differently.

func _ready():
	set_process_input(true)
#this turns listening for input on without this the kinematicBody player wouldnt take input
#this happens when the parent node is first placed in the scene

func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(deg2rad(-event.relative.y))
		$Camera.rotate_y(deg2rad(-event.relative.x))
#this rotates the camera on mouse movement. Relative x and y above

func _physics_process(_delta):
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
