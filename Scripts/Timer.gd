class_name GameTimer
extends Control


@export var max_time: float = 600.0;
@export var answer_sheet: AnswerSheet;
var timer: float = 0.0;
var graded: bool = false;
var time_scale: float = 1.0;
var hand: TextureRect;
var tick: AudioStreamPlayer;

static var instance: GameTimer;


func _ready() -> void:
	hand = $Hand;
	tick = $Tick;
	instance = self;


func _process(delta: float) -> void:
	if(graded): return;
	timer += delta * time_scale;
	
	if(timer > max_time):
		test_graded();
		on_time_run_out();
		return;
	
	hand.rotation = (timer / max_time) * 2 * PI;
	
	if(time_scale != 1.0):
		var l: float = clamp(inverse_lerp(1, 2, time_scale), 0, 1);
		tick.volume_db = lerp(-20, 0, l);
		if(!tick.playing):
			tick.play();
	elif(time_scale == 1.0 && tick.playing):
		tick.stop();


func on_time_run_out() -> void:
	answer_sheet.grade_test();


func test_graded() -> void:
	graded = true;
	tick.stop();
