extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
	
	
	


func _on_rich_text_label_2_meta_clicked(meta: Variant) -> void:
	pass

func _on_antichambretxt_meta_clicked(meta: Variant) -> void:
	if meta == "lvl_1":
		Fadetoblack.transition()
		await Fadetoblack.on_transition_finished
		get_tree().change_scene_to_file("res://rooms/lvl_1.tscn")
