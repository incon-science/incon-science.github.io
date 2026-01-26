extends Node2D

@onready var player: Player = $Player

var exit_door_1 = true
var exit_door_2 = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Engine.time_scale = 1
	if player.position.y > 1000 :
		player.position = Vector2(0,-100)

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.show()
	if body is Player :
		if exit_door_1 and exit_door_2:
			body.position.x = 540
			player.hide()
		
	exit_door_1 = false

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	player.show()
	if body is Player :
		if exit_door_1 and exit_door_2:
			body.position.x = -411
			player.hide()
		
	exit_door_2 = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	exit_door_1 = true

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	exit_door_2 = true
