extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	Fadetoblack.transition()
	await Fadetoblack.on_transition_finished
	get_tree().change_scene_to_file("res://lvl1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
