extends Node2D

var eye_apple_tentacle = null

@onready var lvl_succeed_timer: Timer = $lvl_succeed_timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if %player.got_apple :
		if %player.position.x < %Arm.position.x + 256 + 120: 
			Global.jump_wall = true
			
			%player.got_apple = false
			
			eye_apple_tentacle = %Arm.add_eye()
			$Arm.slowly_add_direction_target(Vector2(42,-34))
			$Arm2.slowly_add_direction_target(Vector2(42,-34))
			
			lvl_succeed_timer.start()
		




func _on_lvl_succeed_timer_timeout() -> void:
	$Label.show()
	Fadetoblack.transition()
	await Fadetoblack.on_transition_finished
	get_tree().change_scene_to_file("res://lvl_3.tscn")
