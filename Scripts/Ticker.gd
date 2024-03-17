class_name Ticker
extends Node2D

@export var time_increment: float = 0.25;
@export var hand_speed: float = 10.0;
@export var size: float = 80;
var dying: bool = false;
var death_timer: float = 0.0;
var death_time: float = 0.2;
var timer: float = 0;
var offset: float = 0
var hand: Sprite2D;


func _ready() -> void:
	hand = $Hand;
	GameTimer.instance.time_scale += time_increment;
	offset = randf_range(0, 2 * PI);
	scale = Vector2(0, 0);
	var tween: Tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), death_time);


func _process(delta: float) -> void:
	timer += delta * hand_speed;
	hand.rotation = timer;
	
	if(dying):
		death_timer += delta;
		if(death_timer > death_time):
			get_parent().remove_child(self);
			queue_free();
		
		var l: float = death_timer / death_time;
		var s: float = smoothstep(1, 0, l);
		scale = Vector2(s, s);


func on_click() -> void:
	GameTimer.instance.time_scale -= time_increment;
	dying = true;
