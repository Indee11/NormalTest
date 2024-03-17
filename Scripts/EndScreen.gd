class_name EndScreen
extends Control


@export var slide_time: float = 1.0;
var sliding: bool = false;
var out: bool = false;
var slide_timer: float = 0.0;
var start_y: float;
var end_y: float = 340;

static var instance: EndScreen;


func _ready() -> void:
	instance = self;
	start_y = position.y;


func _process(delta) -> void:
	if(sliding):
		var l: float;
		if(!out):
			slide_timer += delta;
			l = clamp(1.0 - (slide_timer / slide_time), 0.0, 1.0);
			position.y = lerp(end_y, start_y, l * l * l);
		else:
			slide_timer -= delta;
			l = clamp(slide_timer / slide_time, 0.0, 1.0);
			position.y = lerp(start_y, end_y, l * l * l);
		
		if(slide_timer > slide_time || slide_timer < 0.0):
			sliding = false;
			if(out):
				SceneManager.instance.reload();


func slide_in() -> void:
	sliding = true;


func slide_out() -> void:
	sliding = true;
	out = true;


func try_again_pressed() -> void:
	slide_out();
