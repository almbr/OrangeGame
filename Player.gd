extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FLOOR = Vector2(0, -1)
var state_machine

export var xspeed = 100
export var yspeed = 40

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimatedSprite/AnimationTree.get("parameters/playback")
	#state_machine.start("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	### X MOVEMENT ###
	if Input.is_action_pressed("ui_right"):
		velocity.x = xspeed
		state_machine.travel("Sword walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -xspeed
		state_machine.travel("Sword walk")
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0
		
	### Y MOVEMENT ###
	if Input.is_action_pressed("ui_up"):
		velocity.y = -yspeed
		state_machine.travel("Sword walk")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = yspeed
		state_machine.travel("Sword walk")
	else:
		velocity.y = 0
		
	### Sheathe/unsheathe sword ###
	if Input.is_action_just_pressed("sword"):
		$AnimatedSprite/AnimationTree["parameters/conditions/Sword"] = true
	else:
		$AnimatedSprite/AnimationTree["parameters/conditions/Sword"] = false
		
	### Idle animation ###
	$AnimatedSprite/AnimationTree["parameters/conditions/Idle"] = (velocity.x == 0) and (velocity.y == 0)
	
	#if velocity.x == 0 && velocity.y == 0:
		#if $AnimatedSprite.get_animation() == "Sword walk":
		#	state_machine.travel("Idle sword")
		#else:
		#	state_machine.travel("Idle sword")
		#state_machine.stop()
		
	velocity = move_and_slide(velocity, FLOOR)
