extends CharacterBody2D

class_name Player

const SPEED = 300.0*0.66
const JUMP_VELOCITY = -400.0*0.66

var alive = true

var got_apple = false



func animation(direction):
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

func flip(direction):
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

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		
		'''
		var accelerometer = Input.get_accelerometer()
		if accelerometer == Vector3.ZERO :
			accelerometer = Sensors.get_accelerometer()#HTML5 version
		if accelerometer.y > 0 :
			direction = 1
		elif accelerometer.y < 0 :
			direction = -1
		'''
		
			
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			

		move_and_slide()
		flip(direction)
		animation(direction)
		
		
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
