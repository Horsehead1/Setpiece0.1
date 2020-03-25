extends KinematicBody

# Node references
onready var anim = get_node("Armature/AnimationPlayer")
onready var timer = get_node("Timer")
onready var player = get_parent().get_node("Player")

var player_in_range
var player_in_sight

var rng = RandomNumberGenerator.new()

enum {
	IDLE,
	NEW_DIRECTION,
	MOVE,
	ALERT,
	SEARCH,	
}

# Movement variables
var FOV = 80
var speed = 3
var walkingspeed = 2
var runningspeed = 3
var accel = 8
var vel = Vector3()
var bounce_countdown = 0

var gravity = -40
var max_gravity = -130
var MaxDistance = 300

var state = IDLE

func _ready():
	randomize()

func _process(delta):
	var target = player.get_global_transform().origin
	var pos = get_global_transform().origin
	vel.y += gravity * delta
	if vel.y  < max_gravity:
		vel.y = max_gravity
	match state:
		IDLE:
			anim.play("Idle", 0.15)
		
		NEW_DIRECTION:
			rotation.y = choose([10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180])
			state = choose([IDLE, NEW_DIRECTION])
		
		MOVE:
			speed = walkingspeed
			move(delta)
		
		ALERT:
			if rotation.y <= 180:
				rotation.y += -deg2rad(target.x + pos.y)
				clamp(rotation.y, deg2rad(-70), deg2rad(70))
			else:
				rotation.y += -deg2rad(target.y + pos.x)
				clamp(rotation.y, deg2rad(-70), deg2rad(70))
			speed = runningspeed
			move_to_target(delta)
			if player_in_range == false:
				_on_Timer_timeout()
		SEARCH:
			pass

func _physics_process(_delta):
	SightCheck()

func move_to_target(delta):
		# var target = player.get_global_transform().origin
		# var pos = get_global_transform().origin
		var target_dir = Vector2(0, 0)
		target_dir.y += 1
		set_anim(target_dir)
		vel = move_and_slide(vel, Vector3(0, 1, 0))
		target_dir = target_dir.normalized().rotated(-rotation.y)
		vel.x = lerp(vel.x, target_dir.x * speed, accel * delta)
		vel.z = lerp(vel.z, target_dir.y * speed, accel * delta)

func move(delta):
	var target_dir = Vector2(0, 0)
	target_dir.y += 1
	set_anim(target_dir)
	vel = move_and_slide(vel, Vector3(0, 1, 0))
	target_dir = target_dir.normalized().rotated(-rotation.y)
	vel.x = lerp(vel.x, target_dir.x * speed, accel * delta)
	vel.z = lerp(vel.z, target_dir.y * speed, accel * delta)

func alert():
	pass

func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	get_node("Timer").wait_time = choose([0.5, 1, 1.5, 2])
	state = choose([IDLE])
	
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

func _on_Sight_body_entered(body):
	if body == player:
		player_in_range = true

func _on_Sight_body_exited(body):
	if body == player:
		player_in_range = false

func SightCheck():
	var target = player.get_global_transform().origin
	var pos = get_global_transform().origin
	var space_state = get_world().get_direct_space_state()
	var sight_check = space_state.intersect_ray(pos, target)
	if player_in_range == true:
		if sight_check:
			if sight_check.collider.name == "Player":
				player_in_sight = true
				state = ALERT
			else:
				player_in_sight = false
