extends CharacterBody2D

class_name Player

var intoxiced = false
var intoxiced_time = 0

var alive = true

@onready var boing: AudioStreamPlayer = $boing

var direction = 0
@export_category("move variable")
@export var move_speed = 300.0*0.66
@export var deceleration = 0.2

@export_category("jump variable")
@export var jump_amount=1
@export var jump_speed= 300
@export var acceleration =450

@export var jump_buffer_time = 0.2
var jump_buffer = false


@export_category("wall jump variable")
@export var wall_slide = 150
@onready var left_ray: RayCast2D = $raycast/left_ray
@onready var right_ray: RayCast2D = $raycast/right_ray
@export var wall_x_force = 200.0
@export var wall_y_force = -380.0
var is_wall_jumping = false
var time_to_unlock_movement_before_walljump = 0.12

@export var time_to_unslide = 0.0
var is_sliding = false

@onready var coyote_timer: Timer = $coyote_timer
var coyote_time_activated = false

func movement_logic():
	if not is_wall_jumping:
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
	else :
		if !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
		

func buffer_jump_logic():
	if jump_amount == 0 and Input.is_action_just_pressed("jump"): 
		jump_buffer = true
		get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)

func on_jump_buffer_timeout():
	jump_buffer = false
	
func jump_logic():
	if is_on_floor() or !coyote_timer.is_stopped():
		jump_amount = 1
		if Input.is_action_just_pressed("jump") or jump_buffer:
			coyote_timer.stop()
			coyote_time_activated = true
			jump_buffer = false
			jump_amount -=1
			velocity.y-=lerp(jump_speed, acceleration, 0.1)
			boing.play()
			
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
	if is_on_wall() or !coyote_timer.is_stopped():
		if Input.is_action_just_pressed("jump") or jump_buffer:
			coyote_timer.stop()
			coyote_time_activated = true
			jump_buffer = false
			if left_ray.is_colliding():
				velocity = Vector2(wall_x_force,wall_y_force)
				wall_jumping()
				direction = 1
			if right_ray.is_colliding():
				velocity = Vector2(-wall_x_force,wall_y_force)
				wall_jumping()
				direction = -1

func wall_jumping():
	is_wall_jumping = true
	await get_tree().create_timer(time_to_unlock_movement_before_walljump).timeout
	is_wall_jumping = false

func animation():
	if Global.player_apple :
		$apple.show()
	else :
		$apple.hide()
	
	if intoxiced:
		$AnimatedSprite2D.play("hurt")
		$AnimatedSprite2D2.play("hurt")
		$AnimatedSprite2D3.play("hurt")
		$AnimatedSprite2D4.play("hurt")
	else :
		if is_on_floor():
			$apple.position.y = 3
			if direction == 0:
				$AnimatedSprite2D.play("idle")
				$AnimatedSprite2D2.play("idle")
				$AnimatedSprite2D3.play("idle")
				$AnimatedSprite2D4.play("idle")
			else :
				$AnimatedSprite2D.play("walk")
				$AnimatedSprite2D2.play("walk")
				$AnimatedSprite2D3.play("walk")
				$AnimatedSprite2D4.play("walk")
		else :
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D2.play("jump")
			$AnimatedSprite2D3.play("jump")
			$AnimatedSprite2D4.play("jump")
			
			$apple.position.y = -2
			
		if is_on_wall_only():
			$AnimatedSprite2D.play("fall")
			$AnimatedSprite2D2.play("fall")
			$AnimatedSprite2D3.play("fall")
			$AnimatedSprite2D4.play("fall")
		
func flip():
	if direction > 0 :
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D2.flip_h = false
		$AnimatedSprite2D3.flip_h = false
		$AnimatedSprite2D4.flip_h = false
		
		$apple.position.x = 4
	elif direction < 0 :
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D2.flip_h = true
		$AnimatedSprite2D3.flip_h = true
		$AnimatedSprite2D4.flip_h = true
		
		$apple.position.x = -4

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if alive :
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			
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
		
		if intoxiced :
			intoxiced_time += 10*delta
		else :
			intoxiced_time = 0
		if position.y>600 or intoxiced_time>10:
				die()
				
func die():
	alive = false
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D2.play("death")
	$AnimatedSprite2D3.play("death")
	$AnimatedSprite2D4.play("death")
	
	$die_timer.start()
	
	$die_txt.show()
	
	Global.cpt_lvl[Global.lvl_name]+=1
	
	if Global.player_apple :
		Global.player_apple = false
		Global.lvl1_apple = true

func _on_die_timer_timeout() -> void:
	get_tree().reload_current_scene()
