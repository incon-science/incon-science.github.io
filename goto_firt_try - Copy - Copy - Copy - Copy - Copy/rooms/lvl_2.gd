extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.lvl_name == "lvl_4":
		%player.position = $cube2.position
		$player/Camera2D.position_smoothing_enabled = false
		
	Global.lvl_name = "lvl_2"
	
	$test_roomtxt.text = "test_room"+str(Global.cpt_lvl[Global.lvl_name])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$player/Camera2D.position_smoothing_enabled:$player/Camera2D.position_smoothing_enabled = true
	
	$TextEntity.text = Global.dict_txt_entity[Global.lvl_name]
	
