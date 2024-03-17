class_name AnswerSheet
extends Control

@export var slide_timer: float = 1.0;
@export var in_x: float;
@export var out_x: float;
@export var answers: Array[Answer];
@export var end_screen: Control;
@export var page_parent: PageParent;
var temp_out_x: float;
var timer: float = 0.0;
var out: bool = false;
var sliding: bool = false;
var graded: bool = false;
var end_answers: Label;
var end_comment: Label;


func _ready() -> void:
	var tween: Tween = get_tree().create_tween();
	tween.tween_property(self, "position", Vector2(0.0, position.y), 0.2);
	end_answers = end_screen.get_node("Answers");
	end_comment = end_screen.get_node("Comment");


func _process(delta: float) -> void:
	if(sliding):
		if(out):
			timer += delta;
			if(timer > slide_timer):
				timer = slide_timer;
				sliding = false;
		else:
			timer -= delta;
			if(timer < 0.0):
				timer = 0.0;
				sliding = false;
		
		position.x = lerp(in_x, out_x, smoothstep(0, slide_timer, timer));


func grade_test() -> void:
	if(graded): return;
	graded = true;
	in_x -= 100.0;
	out_x = position.x
	timer = slide_timer;
	out = false;
	sliding = true;
	page_parent.slide_pages();
	
	var num_correct: int = 0;
	var unanswered: bool = false;
	for i in range(answers.size()):
		var answer: Answer = answers[i];
		if(answer.is_correct()):
			num_correct += 1;
		elif(answer.current_answer == -1):
			unanswered = true;
	
	page_parent.can_interact = false;
	end_answers.text = "You got: " + String.num_int64(num_correct) + "/" + String.num_int64(answers.size());
	if(num_correct == 0):
		end_comment.text = "Wow, you almost had to try to get a zero to actually get
		a zero..."
	elif(unanswered):
		end_comment.text = "You didn't even answer all the questions...";
	elif(num_correct < 4):
		end_comment.text = "At least you tried your best?";
	elif(num_correct < 8):
		end_comment.text = "At least you weren't the worst in the class somehow.";
	elif(num_correct < 12):
		end_comment.text = "Pretty good, I guess I was wrong about you being dumb?";
	else:
		end_comment.text = "Wow! You actually got them all right, and here I thought you were a complete dumbass, well done!";


func on_tab_pressed() -> void:
	if(sliding): return;
	sliding = true;
	out = !out;
