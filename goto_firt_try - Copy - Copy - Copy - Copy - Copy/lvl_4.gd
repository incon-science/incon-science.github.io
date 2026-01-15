extends Node2D

@onready var lvl_succeed_timer: Timer = $lvl_succeed_timer
@onready var arm: Arm = %Arm2

var eye_apple_tentacle = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if %player.got_apple :
		if %player.position.x < arm.position.x + 256 + 100: 
			%player.got_apple = false
			
			eye_apple_tentacle = arm.add_eye()
			arm.slowly_add_direction_target(Vector2(42,-34))
			
			lvl_succeed_timer.start()


func _on_lvl_succeed_timer_timeout() -> void:
	Fadetoblack.transition()
	await Fadetoblack.on_transition_finished
	get_tree().change_scene_to_file("res://lvl_4.tscn")
