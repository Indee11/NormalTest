class_name Page
extends RigidBody2D

@export var file_path: String;
@export var text: RichTextLabel;
@export var acceleration: float = 200;
@export var angular_acceleration: float = 2;
@export var centre_grab_factor: float = 0.1;
@export var decceleration: float = 1000;
@export var angular_decceleration: float = 10;
@export var min_time_for_ticker: float = 20.0;
@export var max_time_for_ticker: float = 60.0;
@export var ticker_x: float = 110;
@export var ticker_y: float = 200;
var push_in: bool = false;
var held: bool = false;
var forced: bool = false;
var ticker_timer: float = 0.0;
var ticker_time: float = 0.0;
var force_timer: float = 0.0;
var force_time: float = 0.0;
var offset_distance: float;
var offset: Vector2;
var force: Vector2;
var collision_shape: RectangleShape2D;
var pick: AudioStreamPlayer;


func _ready() -> void:
	collision_shape = $CollisionShape2D.shape;
	pick = $PaperPick;
	file_path = "res://Resources/" + file_path + ".txt";
	text.text = FileAccess.get_file_as_string(file_path);
	ticker_time = randf_range(min_time_for_ticker, max_time_for_ticker);


func _process(delta: float) -> void:
	ticker_timer += delta;
	if(ticker_timer > ticker_time):
		ticker_timer = 0.0;
		ticker_time = randf_range(min_time_for_ticker, max_time_for_ticker);
		
		var ticker: Node2D = load("res://PackedScenes/ticker.tscn").instantiate() as Node2D;
		if(ticker == null): return;
		
		add_child(ticker);
		ticker.position = Vector2(randf_range(-ticker_x, ticker_x), randf_range(-ticker_y, ticker_y));
	
	if(forced):
		force_timer += delta;
		if(force_timer > force_time):
			linear_velocity = force;
			forced = false;


func _physics_process(delta: float) -> void:
	if(held):
		var vec_to_mouse: Vector2 = get_global_mouse_position() - (position + offset);
		linear_velocity += vec_to_mouse * acceleration * delta;
		angular_velocity += offset.angle_to(vec_to_mouse) * offset_distance * centre_grab_factor * angular_acceleration * delta;
	else:
		if(linear_velocity != Vector2.ZERO):
			var normalised_velocity: Vector2 = linear_velocity.normalized();
			linear_velocity -= normalised_velocity * decceleration * delta;
			var v: Vector2 = linear_velocity;
			var normedv: Vector2 = linear_velocity.normalized();
			if(!linear_velocity.normalized().is_equal_approx(normalised_velocity)):
				linear_velocity = Vector2.ZERO;
		if(angular_velocity != 0.0):
			var sign_av: float = sign(angular_velocity);
			angular_velocity -= sign(angular_velocity) * angular_decceleration * delta;
			if(sign(angular_velocity) != sign_av):
				angular_velocity = 0.0;
		if(!push_in): return;
		if(abs(position.x) > 600):
			linear_velocity.x -= sign(position.x) * delta * 1500;
		if(abs(position.y) > 350):
			linear_velocity.y -= sign(position.y) * delta * 1500;
	
	if(!push_in && abs(position.x) < 640 && abs(position.y) < 350):
		push_in = true;


func hold() -> void:
	pick.play();
	move_to_front();
	offset = get_global_mouse_position() - position;
	offset_distance = offset.length();
	held = true;
	
	var tween: Tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(1.01, 1.01), 0.05);
	tween.tween_property(self, "scale", Vector2(1, 1), 0.05);


func unhold() -> void:
	held = false;


func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_MOUSE_EXIT):
		held = false;
	elif(what == NOTIFICATION_APPLICATION_FOCUS_OUT):
		held = false;


func push(push_force: Vector2, delay: float) -> void:
	if(delay <= 0.0):
		linear_velocity = push_force;
	else:
		forced = true;
		force_timer = 0.0;
		force_time = delay;
		force = push_force;
