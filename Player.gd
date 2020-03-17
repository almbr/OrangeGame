extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FLOOR = Vector2(0, -1)
const pixel_width = 23

var state_machine
var arm_state_machine
var mouse_pos = Vector2()

export var xspeed = 100
export var yspeed = 40

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimatedSprite/AnimationTree.get("parameters/playback")
	arm_state_machine = $AnimatedSprite/Arm/AnimationTree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	### X MOVEMENT ###
	if Input.is_action_pressed("ui_right"):
		velocity.x = xspeed
		state_machine.travel("Sword walk")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -xspeed
		state_machine.travel("Sword walk")
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
	#if Input.is_action_just_pressed("sword"):
	#	$AnimatedSprite/AnimationTree["parameters/conditions/Sword"] = true
	#else:d
	#	$AnimatedSprite/AnimationTree["parameters/conditions/Sword"] = false
		
	### Aim sword ###
	mouse_pos = get_viewport().get_mouse_position()
	var angle = rad2deg($AnimatedSprite/Arm.global_position.angle_to_point(mouse_pos))
	var angle_diff = angle - $AnimatedSprite/Arm.rotation_degrees - 180
	$AnimatedSprite/Arm.rotation_degrees += angle_diff
	
	### H flip ###
	if (angle > -90) and (angle < 90) and ($AnimatedSprite.flip_h == false):
		$AnimatedSprite.flip_h = true
		$AnimatedSprite/Arm.flip_v = true
		$AnimatedSprite/Arm.position -= Vector2(pixel_width, 0)
		$AnimatedSprite/Arm.offset += Vector2(0, pixel_width)
	elif ((angle < -90) or (angle > 90)) and ($AnimatedSprite.flip_h == true):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite/Arm.flip_v = false
		$AnimatedSprite/Arm.position += Vector2(pixel_width, 0)
		$AnimatedSprite/Arm.offset -= Vector2(0, pixel_width)
	
	### Attack ###	
	if Input.is_action_pressed("attack"):
		arm_state_machine.travel("Attack")
	
	### Idle animation ###
	$AnimatedSprite/AnimationTree["parameters/conditions/Idle"] = (velocity.x == 0) and (velocity.y == 0)
	
		
	velocity = move_and_slide(velocity, FLOOR)
