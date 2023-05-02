extends CharacterBody2D

const GRAVITY = 3900

const bulletPath = preload('res://scenes/Bullet.tscn')

const WALK_SPEED = 650
const JUMP_SPEED = 1500
const GROUND_POUND_SPEED = 1300
const REBOUND_SPEED = 800

const Direction = {
	STEADY = 0,
	LEFT = -1,
	RIGHT = 1
}

const Status = {
	POWER_UP = 3,
	NORMAL = 2,
	SMALL = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D

var status
var direction = Direction.STEADY
var direction_watching = Direction.RIGHT

var crouch = false
var ground_pound = false
var ground_pound_pause = 0
var rebound = false
var rebound_pause = 0
var shot = false
var shot_pause = 0

var just_hitted = false

func hit():
	just_hitted=true
	status_down()
	
func animate():
	if velocity.x != 0:
		animation.flip_h = velocity.x < 0
	
	if not crouch and not ground_pound:
		animation.scale = Vector2(0.2, 0.2)
	elif status > Status.SMALL:
		animation.scale = Vector2(0.25, 0.25)
	
	if crouch:
		animation.animation = "crouch"
		animation.stop()
	elif ground_pound:
		animation.animation = "ground_pound"
		animation.stop()
	elif not is_on_floor():
		animation.animation = "jump"
		animation.stop()
	elif abs(velocity.x) > 100:
		animation.play("walk")
	else:
		animation.animation = "steady"
		animation.stop()

func resize_hitbox():
	if status == Status.SMALL:
		if crouch:
			scale.y = 1 * 0.75
		elif is_on_floor():
			position.y -= 32
			scale.y = 1
		return
	
	if crouch:
		position.y += 32
		scale.y = 1
	elif ground_pound:
		scale.y = 1
	elif is_on_floor():
		position.y -= 32
		scale.y = 2

func move(delta):
	direction = Direction.STEADY
	
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("shift"):
		if is_on_floor():
			crouch = true
		else:
			ground_pound = true
		resize_hitbox()
	
	if Input.is_action_just_released("ui_down") or Input.is_action_just_released("shift") and is_on_floor():
		crouch = false
		resize_hitbox()
	
	if ground_pound:
		if ground_pound_pause < 15 * delta:
			ground_pound_pause += delta
			animation.rotate(0.447)
			return
		
		animation.rotation = 0
		velocity = Vector2(0, GROUND_POUND_SPEED)
		move_and_slide()
		
		if is_on_floor():
			if ground_pound_pause < 40 * delta:
				ground_pound_pause += delta
				return
			
			ground_pound = false
			ground_pound_pause = 0
			resize_hitbox()
			
			if Input.is_action_pressed("ui_down") or Input.is_action_pressed("shift"):
				crouch = true
				resize_hitbox()
		return
	
	if crouch and not just_hitted:
		velocity.x = lerpf(velocity.x, 0, 0.07)
		move_and_slide()
		return
	
	just_hitted = false
	
	if Input.is_action_pressed("ui_right"):
		direction = Direction.RIGHT
		direction_watching = direction
	if Input.is_action_pressed("ui_left"):
		direction = Direction.LEFT
		direction_watching = direction
	
	if Input.is_action_just_pressed("ui_select") and is_on_wall() and not is_on_floor():
		velocity.y = -JUMP_SPEED
		velocity.x = -WALK_SPEED * direction
	
	elif Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = lerpf(velocity.y, 0, 0.4)
	
	velocity.x = lerpf(velocity.x, WALK_SPEED * direction, 0.04)
	
	if rebound:
		velocity.x = 0
		rebound_pause += delta
		if rebound_pause < 2 * delta:
			velocity.y = -REBOUND_SPEED
		else:
			rebound_pause = 0
			rebound = false
	
	move_and_slide()

func ability(delta):
	if status != Status.POWER_UP:
		return
	
	if Input.is_action_just_pressed("shoot") and shot == false:
		shoot()
		shot = true
	
	if shot:
		if shot_pause > 0.24:
			shot_pause = 0
			shot = false
		else:
			shot_pause += delta

func shoot():
	var positon_offset = Vector2(32 * direction_watching, 0)
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = position + positon_offset
	bullet.direction = direction_watching

func status_down():
	if status > Status.DEAD:
		status -= 1
	match_status()

func status_up():
	if status < Status.POWER_UP:
		status += 1
	match_status()

func match_status():
	if scale.y == 1:
		position.y -= 32
	
	match status:
		Status.POWER_UP:
			scale.y = 2
		Status.NORMAL:
			scale.y = 2
		Status.SMALL:
			scale.y = 1
		Status.DEAD:
			respawn()

func respawn():
	position.x = 500
	position.y = -500
	status = Status.SMALL
	match_status()

func tilemap_interactions():
	if is_on_ceiling():
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMap and collider.has_method("hit"):
			collider.hit(position, direction_watching)

func _ready():
	# DEBUG
	status = Status.NORMAL
	
	position = Vector2(0, -96)
	set_up_direction(Vector2.UP)
	match_status()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if position.y > 350:
		respawn()

func _process(delta):
	move(delta)
	ability(delta)
	tilemap_interactions()
	animate()
