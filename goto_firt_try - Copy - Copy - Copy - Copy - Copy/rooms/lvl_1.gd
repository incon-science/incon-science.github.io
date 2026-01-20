extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.lvl_name == "lvl_2":
		%player.position = $cube.position
		$player/Camera2D.position_smoothing_enabled = false
		
	Global.lvl_name = "lvl_1"
	
	if Global.lvl1_apple :
		$apple.show()
		$apple.set_process_mode(Node.PROCESS_MODE_INHERIT)
	else :
		$apple.hide()
		$apple.set_process_mode(Node.PROCESS_MODE_DISABLED)
		
	$test_roomtxt.text = "test_room"+str(Global.cpt_lvl[Global.lvl_name])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$player/Camera2D.position_smoothing_enabled:$player/Camera2D.position_smoothing_enabled = true

func _on_apple_body_entered(body: Node2D) -> void:
	if body is Player:
		if not Global.player_apple :
			Global.player_apple = true 
			Global.lvl1_apple = false
			$apple.hide()
			$apple.set_process_mode(Node.PROCESS_MODE_DISABLED)
			

			
