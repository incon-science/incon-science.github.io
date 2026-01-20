extends Area2D

@export_category("teleport to")
@export var scene_target = ""
var inside_cube = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	inside_cube = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	
	if body is Player :
		if not inside_cube :
			Fadetoblack.transition(6)
			await Fadetoblack.on_transition_finished
			get_tree().change_scene_to_file("res://rooms/"+scene_target+".tscn")


func _on_body_exited(body: Node2D) -> void:
	if body is Player :
		inside_cube = false
