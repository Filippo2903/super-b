extends CharacterBody2D

const GRAVITY = 3900

const Speed = {
	WALK = 650,
	WALL_JUMP = 15000,
	JUMP = 1500,
	GROUND_POUND = 1300,
}

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

const bulletPath = preload('res://scenes/Bullet.tscn')

@onready var animation = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D

var status
var direction = Direction.STEADY
var direction_watching = Direction.RIGHT

var crouch = false
var ground_pound = false
var ground_pound_pause = 0
var rebounding = false
var rebound_pause = 0
var rebound_speed
var shot = false
var shot_pause = 0

var hitted = false

func hit():
	invulnerability()
	blink()
	hitted = true
	status_down()

func init_invulnerability_timer():
	var invulnerability_timer = get_node("InvulnerabilityTimer")
	var invulnerability_callable = Callable(self, "remove_invulnerability")
	invulnerability_timer.connect("timeout", invulnerability_callable)
	invulnerability_timer.set_wait_time(2)

func init_blink_timer():
	var blink_timer = get_node("BlinkTimer")
	var visibility_callable = Callable(self, "visibility")
	blink_timer.connect("timeout", visibility_callable)
	blink_timer.set_wait_time(0.15)

func invulnerability():
	set_collision_layer_value(2, false)
	set_collision_mask_value(3, false)
	get_node("InvulnerabilityTimer").start()

func blink():
	animation.visible = false
	get_node("BlinkTimer").start()

func visibility():
	animation.visible = true if animation.visible == false else false

func remove_invulnerability():
	get_node("BlinkTimer").stop()
	animation.visible = true
	
	set_collision_layer_value(2, true)
	set_collision_mask_value(3, true)

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

func rebound(speed):
	rebound_speed = speed
	rebounding = true

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
		velocity = Vector2(0, Speed.GROUND_POUND)
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
	
	if crouch and not hitted:
		velocity.x = lerpf(velocity.x, 0, 0.07)
		move_and_slide()
		return
	
	hitted = false
	
	if Input.is_action_pressed("ui_right"):
		direction = Direction.RIGHT
		direction_watching = direction
	if Input.is_action_pressed("ui_left"):
		direction = Direction.LEFT
		direction_watching = direction
	
	if Input.is_action_just_pressed("ui_select") and is_on_wall_only():
		velocity.y = lerpf(velocity.y, -Speed.WALL_JUMP, 0.08)
		velocity.x = lerpf(velocity.x, -Speed.WALK * 25 * direction_watching, 0.08)
	
	elif Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = -Speed.JUMP
	elif Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = lerpf(velocity.y, 0, 0.4)
	
	velocity.x = lerpf(velocity.x, Speed.WALK * direction, 0.08)
	
	if rebounding:
		rebound_pause += delta
		if rebound_pause < 2 * delta:
			velocity.y = -rebound_speed
		else:
			rebound_pause = 0
			rebounding = false
	
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

func status_normal():
	if status < Status.NORMAL:
		status = Status.NORMAL
	match_status()

func status_power_up():
	if status < Status.POWER_UP:
		status = Status.POWER_UP
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
	if is_on_floor() and get_last_slide_collision() != null:
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMap and collider.has_method("jump"):
			collider.jump(position)
	if is_on_ceiling() and get_last_slide_collision() != null:
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMap and collider.has_method("hit"):
			collider.hit(position, direction_watching, status)

func _ready():
	# DEBUG
	status = Status.NORMAL
	
	set_up_direction(Vector2.UP)
	match_status()
	
	init_blink_timer()
	init_invulnerability_timer()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if position.y > 350:
		respawn()

func _process(delta):
	move(delta)
	ability(delta)
	tilemap_interactions()
	animate()
