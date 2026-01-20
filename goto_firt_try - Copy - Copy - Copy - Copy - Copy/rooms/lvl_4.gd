extends Node2D

@onready var arm: Arm = %Arm

var eye_apple_tentacle = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.lvl_name == "lvl_3":
		%player.position = $cube2.position
		$player/Camera2D.position_smoothing_enabled = false
	Global.lvl_name = "lvl_4"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$player/Camera2D.position_smoothing_enabled:$player/Camera2D.position_smoothing_enabled = true
	
	$TextEntity.text = Global.dict_txt_entity[Global.lvl_name]
	
	if Global.player_apple :
		if %player.position.x > arm.position.x + 256 - 100 and %player.position.y < arm.position.y + 256 +100: 
			Global.player_apple = false
			
			eye_apple_tentacle = arm.add_eye()
			arm.slowly_add_direction_target(Vector2(42,-34))
			
			Global.dict_txt_entity[Global.lvl_name] = "aga1in!"
			Global.dict_txt_entity["lvl_2"] = "agai0n!"
			
			Global.cpt_feed +=1
			
