class_name Answer
extends Control


@export var question_id: int;
@export var correct_answer: int;
@export var pressed_texture: Texture2D;
@export var unpressed_texture: Texture2D;
@export var question_label: Label;
var current_answer: int = -1;
var pencil_sound: AudioStreamPlayer;


func _ready() -> void:
	pencil_sound = $PencilCheck;
	question_label.text = String.num_int64(question_id + 1) + ".";
	var text: String = question_label.text;


func answer_pressed(answer_id: int) -> void:
	for i in range(get_child_count()):
		var answer: AnswerCircle = get_child(i) as AnswerCircle;
		if(answer == null): continue;
		
		answer.unpress();
	current_answer = answer_id;
	
	pencil_sound.play();


func is_correct() -> bool:
	return current_answer == correct_answer;
