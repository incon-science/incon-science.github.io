extends Node2D

@onready var lvl_succeed_timer: Timer = $lvl_succeed_timer

var eye_apple_tentacle = null

func duplicate_room1(offset,rotate_bool= true):
	var r = $room1.duplicate()
	r.position = r.position + offset 
	$".".add_child(r)  
	if rotate_bool :
		r.set_rotation_degrees(180)



# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if not 1 :
		for i in range(-4,5):
			
			duplicate_room1(Vector2(0+i*438,0),false)
			
			duplicate_room1(Vector2(-438+i*438,0),false)
			duplicate_room1(Vector2(438+i*438,0),false)
			
			duplicate_room1(Vector2(438+i*438,-292))
			duplicate_room1(Vector2(-438+i*438,292))
			
			duplicate_room1(Vector2(438+i*438,292))
			duplicate_room1(Vector2(-438+i*438,-292))
			
			duplicate_room1(Vector2(0+i*438,-292))
			duplicate_room1(Vector2(0+i*438,292))
		
		$room1.hide()
		$room1.process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if %player.got_apple :
		if %player.position.x > %Arm.position.x + 256 - 120: 
			%player.got_apple = false
			
			eye_apple_tentacle = %Arm.add_eye()
			$Arm.slowly_add_direction_target(Vector2(42,-34))
			
			lvl_succeed_timer.start()



func _on_lvl_succeed_timer_timeout() -> void:
	Fadetoblack.transition()
	await Fadetoblack.on_transition_finished
	get_tree().change_scene_to_file("res://lvl_4.tscn")
