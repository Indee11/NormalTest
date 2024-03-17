class_name PageParent
extends Node2D


@export var answer_page: Control;
var can_interact: bool = true;
var ui_priority: bool = false;
var sliding: bool = false;
var slide_timer: float = 0.0;
var slide_time: float = 1.0;
var answer_page_size: Vector2 = Vector2(336, 504);
var answer_page_position: Vector2 = Vector2(-168, 0);


func _ready() -> void:
	for i in range(get_child_count() - 1, -1, -1):
		var page: Page = get_child(i) as Page;
		if(page == null): continue;
		
		page.push(Vector2(randf_range(-20.0, 20.0), randf_range(1120.0, 1180.0)), randf_range(0.4, 1.2));


func _process(delta: float) -> void:
	if(sliding):
		slide_timer += delta;
		if(slide_timer > slide_time):
			sliding = false;
			EndScreen.instance.slide_in();


func _input(event: InputEvent) -> void:
	if(!can_interact): return;
	
	if(event.is_action("Click")):
		if(event.is_action_pressed("Click")):
			if(ui_priority): return;
			if(point_AABB_collision(answer_page.get_global_mouse_position(), answer_page_position + answer_page.position, answer_page_size)):
				return; # dodgiest solution out there
			
			var page: Page = look_for_focussed_page();
			if(page == null): return;
			
			var ticker: Ticker = look_for_pressed_ticker(page);
			if(ticker != null):
				ticker.on_click();
				return;
			
			page.hold();
			get_tree().root.get_viewport().set_input_as_handled();
		else:
			unhold_pages();
			get_tree().root.get_viewport().set_input_as_handled();


func look_for_focussed_page() -> Page:
	var mouse: Vector2 = get_global_mouse_position();
	for i in range(get_child_count() - 1, -1, -1):
		var page: Page = get_child(i) as Page;
		if(page == null): continue;
		
		if(point_box_collision(mouse, page.position, page.rotation, page.collision_shape.size)):
			return page;
	
	return null;


func look_for_pressed_ticker(page: Page) -> Ticker:
	for i in range(page.get_child_count() - 1, -1, -1):
		var ticker: Ticker = page.get_child(i) as Ticker;
		if(ticker == null): continue;
		
		if(point_box_collision(get_global_mouse_position(), ticker.global_position, page.rotation, Vector2(ticker.size, ticker.size))):
			return ticker;
	return null;


func point_box_collision(point: Vector2, box_centre: Vector2, box_rotation: float, box_size: Vector2) -> bool:
	var box_vector: Vector2 = Vector2(0.0, -1.0).rotated(box_rotation);
	var box_perp_vector: Vector2 = box_vector.rotated(PI / 2.0);
	var point_relative: Vector2 = point - box_centre;
	var dist_y: float = abs(point_relative.dot(box_vector));
	var dist_x: float = abs(point_relative.dot(box_perp_vector));
	if(dist_x < box_size.x / 2.0 && dist_y < box_size.y / 2.0):
		return true;
	return false;


func point_AABB_collision(point: Vector2, box_centre: Vector2, box_size: Vector2) -> bool:
	var half_box_x: float = box_size.x / 2;
	var half_box_y: float = box_size.y / 2;
	if(point.x > box_centre.x - half_box_x && point.x < box_centre.x + half_box_x):
		if(point.y > box_centre.y - half_box_y && point.y < box_centre.y + half_box_y):
			return true;
	return false;


func unhold_pages() -> void:
	for i in range(get_child_count()):
		var page: Page = get_child(i) as Page;
		if(page == null): continue;
		
		page.unhold();


func slide_pages() -> void:
	for i in range(get_child_count() - 1, -1, -1):
		var page: Page = get_child(i) as Page;
		if(page == null): continue;
		
		page.push_in = false;
		page.push(Vector2(0.0, -2000.0), 0.0);
	sliding = true;


func set_to_ui_priority() -> void:
	ui_priority = true;


func set_to_page_priority() -> void:
	ui_priority = false;
