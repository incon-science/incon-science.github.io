extends CharacterBody2D

class_name Player

var alive = true
@onready var camera_2d: Camera2D = $Camera2D

var direction = 0
@export var move_speed = 300.0*0.66
@export var deceleration = 0.15

@export var jump_speed= 300
@export var acceleration =450

@export var jump_buffer_time = 0.15
var jump_buffer = false

@export var wall_slide = 150
@onready var left_ray: RayCast2D = $raycast/left_ray
@onready var right_ray: RayCast2D = $raycast/right_ray
@export var wall_x_force = 200.0
@export var wall_y_force = -380.0
var is_wall_jumping = false

@export var time_to_unslide = 0.0
var is_sliding = false

@onready var coyote_timer: Timer = $coyote_timer
var coyote_time_activated = false
var coyote_type = 0 #0 floor / -1 wall left / 1 wall right

func _ready() -> void:
	camera_2d.position_smoothing_speed=5

func movement_logic():
	if not is_wall_jumping:
		if Input.is_action_pressed("run"):
			move_speed = 300.0*1
		else :
			move_speed = 300.0*0.66
		
		direction = Input.get_axis("left", "right")
		if direction != 0 and is_sliding:
			await get_tree().create_timer(time_to_unslide).timeout
		if direction:
			velocity.x = direction * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed*deceleration)

func coyote_logic():
	if is_on_floor() or is_on_wall():
		if coyote_time_activated:
			coyote_time_activated = false
			coyote_timer.stop()
	else:
		if !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
			
	if is_on_floor():coyote_type=0
	if is_on_wall():
		if left_ray.is_colliding():coyote_type=-1
		if right_ray.is_colliding():coyote_type=1

func buffer_jump_logic():
	if !is_on_floor() and !is_on_wall() and Input.is_action_just_pressed("jump"): 
		jump_buffer = true
		get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)

func on_jump_buffer_timeout():
	jump_buffer = false
	
func jump_logic():
	if is_on_floor() or (!coyote_timer.is_stopped() and coyote_type==0):
		if Input.is_action_just_pressed("jump") or jump_buffer:
			coyote_timer.stop()
			coyote_time_activated = true
			jump_buffer = false
			velocity.y = 0
			velocity.y-=lerp(jump_speed, acceleration, 0.1)
			$hero_jump.play()
			
	if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y=lerp(velocity.y, get_gravity().y, 0.2)
			velocity.y *= 0.1

func slide_logic():
	if is_on_wall_only():
		if left_ray.is_colliding() and Input.is_action_pressed("left"):
			is_sliding = true
		elif right_ray.is_colliding() and Input.is_action_pressed("right"):
			is_sliding = true
	else :
		is_sliding = false
			
	if is_sliding :
		velocity.y = wall_slide

func wall_logic():
	if is_on_wall() or (!coyote_timer.is_stopped() and (coyote_type==-1 or coyote_type==1)):
		if Input.is_action_just_pressed("jump") or jump_buffer:
			coyote_timer.stop()
			coyote_time_activated = true
			jump_buffer = false
			if left_ray.is_colliding() or coyote_type==-1:
				velocity = Vector2(wall_x_force,wall_y_force)
				wall_jumping()
				direction = 1
			if right_ray.is_colliding() or coyote_type==1:
				velocity = Vector2(-wall_x_force,wall_y_force)
				wall_jumping()
				direction = -1
			$hero_walljump.play()

func wall_jumping():
	is_wall_jumping = true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false
				
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		
	if alive :
		if not is_on_floor():
			velocity += get_gravity() * delta
			if velocity.y > 600:
				velocity.y = 600
			
		movement_logic()
		
		coyote_logic()
		buffer_jump_logic()
		
		jump_logic()
		
		slide_logic()
		if Global.jump_wall :
			wall_logic()
			
		move_and_slide()
		
		flip()
		animation()
		
		death_logic(delta)
		
		ground_sound_logic()
				
func die():
	alive = false
	playanimation("death")
	
	$die_timer.start()
	
	$die_txt.show()
	
	if Global.lvl_name != "":
		Global.cpt_lvl[Global.lvl_name]+=1
	
	if Global.player_apple :
		Global.player_apple = false
		Global.lvl1_apple = true

func _on_die_timer_timeout() -> void:
	get_tree().reload_current_scene()

var intoxiced = false
var intoxiced_time = 0
func death_logic(delta):
	if intoxiced :
		intoxiced_time += 10*delta
	else :
		intoxiced_time = 0
	if position.y>600 or intoxiced_time>10:
			die()
			
func playanimation(anim_name):
	$AnimatedSprite2D.play(anim_name)
	$AnimatedSprite2D2.play(anim_name)
	$AnimatedSprite2D3.play(anim_name)
	$AnimatedSprite2D4.play(anim_name)

func animation():
	if Global.player_apple :
		$apple.show()
	else :
		$apple.hide()
	
	if intoxiced:
		playanimation("hurt")
	else :
		if is_on_floor():
			$apple.position.y = 3
			if direction == 0:
				playanimation("idle")
			else :
				if Input.is_action_pressed("run"):
					playanimation("run")
				else:
					playanimation("walk")
		else :
			playanimation("jump")
			$apple.position.y = -2
		if is_on_wall_only():
			playanimation("fall")

func flip_animation(boolean_value):
	$AnimatedSprite2D.flip_h = boolean_value
	$AnimatedSprite2D2.flip_h = boolean_value
	$AnimatedSprite2D3.flip_h = boolean_value
	$AnimatedSprite2D4.flip_h = boolean_value

var decalage_camera = 25	
func flip():
	if direction > 0 :
		flip_animation(false)
		$apple.position.x = 4
	elif direction < 0 :
		flip_animation(true)
		$apple.position.x = -4
		
var was_on_air = false
func ground_sound_logic():
	if is_on_floor():
		if was_on_air:
			$hero_land.play()
			was_on_air = false
	else :
		was_on_air = true
	
