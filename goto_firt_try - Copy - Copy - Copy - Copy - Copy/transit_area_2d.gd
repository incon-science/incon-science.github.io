extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.z_index=-1
		body.move_speed = 300.0*1


func _on_body_exited(body: Node2D) -> void:
	if body is Player :
		body.z_index=2
		body.move_speed = 300.0*0.66
