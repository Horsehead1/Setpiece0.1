extends KinematicBody

onready var anim = get_node("Armature/AnimationPlayer")
onready var cam = get_node("Camera")
onready var cam2 = get_node("Target/Camera")
onready var skel = get_node("Armature")

var headbone
var initial_head_transform

var max_health
var current_health = 10

var speed = 3
var walkspeed = 3
var crouchspeed = 1
var runspeed = 10
var accel = 8
var vel = Vector3()

var sensitivity = 0.2

var gravity = -40
var max_gravity = -130

var jump_force = 10

var jumping = false
var crouching = false
var running = false

func _ready():
	max_health = current_health
	#hide cursor and set headbone
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	headbone = skel.find_bone("Head")
	initial_head_transform = skel.get_bone_pose(headbone)

func _input(event):
	if Input.is_action_pressed("highlight"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#head and body rotation
		if event is InputEventMouseMotion:
			var movement = event.relative
			cam.rotation.x += -deg2rad(movement.y * sensitivity)
			cam.rotation.x = clamp(cam.rotation.x, deg2rad(-70), deg2rad(70))
			rotation.y += -deg2rad(movement.x * sensitivity)

func _process(delta):
#	if Input.is_action_just_pressed("menu"):
#		add_child(mainmenu.instance())
#		get_tree().paused = true
	
	#switch camera
	if Input.is_action_just_pressed("switch_cam"):
		if cam.current:
			cam.current = false
		else:
			cam.current = true
	
	var target_dir = Vector2(0, 0)
	#check for move player input
	if Input.is_action_pressed("forward"):
		target_dir.y += 1
	if Input.is_action_pressed("backward"):
		target_dir.y -= 1
	if Input.is_action_pressed("left"):
		target_dir.x += 1
	if Input.is_action_pressed("right"):
		target_dir.x -= 1
	
	#set player direction
	if not jumping or crouching or running:
		set_anim(target_dir)
	
	if crouching:
		speed = crouchspeed
	if running:
		speed = runspeed
	elif not Input.is_action_pressed("crouch") or Input.is_action_pressed("run"):
		speed = walkspeed
	
	target_dir = target_dir.normalized().rotated(-rotation.y)
	
	#set acceleration
	vel.x = lerp(vel.x, target_dir.x * speed, accel * delta)
	vel.z = lerp(vel.z, target_dir.y * speed, accel * delta)
	
	vel.y += gravity * delta
	if vel.y  < max_gravity:
		vel.y = max_gravity
	
	#jumping and crouching
	if Input.is_action_pressed("crouch") and not (anim.current_animation == "Crouch" or jumping or running):
		anim.play("Crouch", 0,2)
		crouching = true
	elif not Input.is_action_pressed("crouch") or jumping and crouching:
		crouching = false
	
	if Input.is_action_pressed("run") and not (crouching or jumping):
		running = true
	elif not Input.is_action_pressed("run"):
		running = false
	
	if Input.is_action_pressed("jump") and is_on_floor():
		running = false
		vel.y = jump_force
		anim.play("Jump", 0.1)
		jumping = true
	
	vel = move_and_slide(vel, Vector3(0, 1, 0))
	
	if is_on_floor():
		vel.y = 0
		jumping = false
	
	
	#rotation of head
	var current_head_transform = initial_head_transform.rotated(Vector3(-1, 0, 0), cam.rotation.x)
	skel.set_bone_pose(headbone, current_head_transform)

func set_anim(dir):
	#set animations for walking
	if dir == Vector2(0, 0) and anim.current_animation != "Idle":
		anim.play("Idle", 0.15)
	elif dir == Vector2(0, 1) and anim.current_animation != "WalkForward":
		anim.play("WalkForward", 0.15)
	elif dir == Vector2(1, 1) and anim.current_animation != "WalkUpLeft":
		anim.play("WalkUpLeft", 0.15)
	elif dir == Vector2(-1, 1) and anim.current_animation != "WalkUpRight":
		anim.play("WalkUpRight", 0.15)
	elif dir == Vector2(1, 	0) and anim.current_animation != "WalkLeft":
		anim.play("WalkLeft", 0.15)
	elif dir == Vector2(-1, 0) and anim.current_animation != "WalkRight":
		anim.play("WalkRight", 0.15)
	elif dir == Vector2(0, -1) and anim.current_animation != "WalkBackward":
		anim.play("WalkBackward", 0.15)
	elif dir == Vector2(1, -1) and anim.current_animation != "WalkDownLeft":
		anim.play("WalkDownLeft", 0.15)
	elif dir == Vector2(-1, -1) and anim.current_animation != "WalkDownRight":
		anim.play("WalkDownRight", 0.15)
	
