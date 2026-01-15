extends CharacterBody2D

class_name Player2

var alive = true
var got_apple = false

var direction = 0

const move_speed = 300.0*0.66
const deceleration = 0.1

const JUMP_VELOCITY = -400.0*0.66

var jump_amount=1
var jump_speed= 300
var acceleration =450
var gravity = 500.0



@export_category("wall jump variable")
@export var wall_slide = 60
@onready var left_ray: RayCast2D = $raycast/left_ray
@onready var right_ray: RayCast2D = $raycast/right_ray
@onready var bottom_ray: RayCast2D = $raycast/bottom_ray
@export var wall_x_force = 225.0
@export var wall_y_force = -280.0
var is_wall_jumping = false

func wall_logic():
	if is_on_wall_only():
		if not bottom_ray.is_colliding():
			velocity.y = wall_slide
		if Input.is_action_just_pressed("jump"):
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
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false

func jump_logic():
	if is_on_floor():
		jump_amount = 1
		if Input.is_action_just_pressed("jump"):
			jump_amount -=1
			velocity.y-=lerp(jump_speed, acceleration, 0.1)

	if not is_on_floor():
		if jump_amount>0:
			if Input.is_action_just_pressed("jump"):
				jump_amount -=1
				velocity.y-=lerp(jump_speed, acceleration, 1)
				
			if Input.is_action_just_released("jump"):
				velocity.y-=lerp(velocity.y, gravity, 0.2)
				velocity.y *= 0.3
	else:
		return
		
func movement_logic():
	if not is_wall_jumping:
		direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed*deceleration)

func animation():
	if got_apple :
		$apple.show()
	else :
		$apple.hide()
	
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
		
		jump_logic()
		
		if Global.jump_wall :
			wall_logic()
			
		move_and_slide()
		
		flip()
		animation()
		
		if velocity.y>1000:
				die()
	
func die():
	alive = false
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D2.play("death")
	$AnimatedSprite2D3.play("death")
	$AnimatedSprite2D4.play("death")
	
	$die_timer.start()
	
	$die_txt.show()




func _on_die_timer_timeout() -> void:
	get_tree().reload_current_scene()
