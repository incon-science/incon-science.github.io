extends Node2D

var in_area = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$txt.hide()
	$page1.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area :
		if Input.is_action_just_pressed("up"):
			$page1.show()
			Global.jump_wall = true
			$txt.hide()
	
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		$page1.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		$txt.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false
		$txt.hide()
