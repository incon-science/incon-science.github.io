extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	
	if Global.lvl_name != "lvl_1":
		Fadetoblack.transition()
		await Fadetoblack.on_transition_finished
		get_tree().change_scene_to_file("res://rooms/lvl_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://rooms/lvl_1.tscn")
