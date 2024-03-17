extends Control


var paused: bool = false;


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause")):
		if(paused): unpause();
		else: pause();


func pause() -> void:
	paused = true;
	get_tree().paused = true;
	show();


func unpause() -> void:
	paused = false;
	get_tree().paused = false;
	hide();
