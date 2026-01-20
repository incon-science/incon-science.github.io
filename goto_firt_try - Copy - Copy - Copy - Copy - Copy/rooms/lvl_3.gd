extends Node2D


func duplicate_room1(offset,rotate_bool= true):
	var r = $room1.duplicate()
	r.position = r.position + offset 
	$".".add_child(r)  
	if rotate_bool :
		r.set_rotation_degrees(180)

func _ready() -> void:
	Global.lvl_name = "lvl_3"
	
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
	if !$player/Camera2D.position_smoothing_enabled:$player/Camera2D.position_smoothing_enabled = true
