class_name AnswerCircle
extends TextureButton

@export var answer_id: int;
@export var answer: Answer;


func _ready() -> void:
	connect("button_down", on_press);


func _process(delta: float) -> void:
	pass


func on_press() -> void:
	answer.answer_pressed(answer_id);
	press();


func press() -> void:
	texture_normal = answer.pressed_texture;


func unpress() -> void:
	texture_normal = answer.unpressed_texture;
