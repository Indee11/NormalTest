class_name SceneManager
extends Node2D

static var scene_name: String = "res://Scenes/main.tscn";
static var instance: SceneManager;


func _ready() -> void:
	instance = self;


func reload() -> void:
	if(!ResourceLoader.exists(scene_name)): return;
	
	var scene: PackedScene = load(scene_name) as PackedScene;
	if(scene == null): return;
	
	var node: Node = get_child(0);
	remove_child(node);
	node.queue_free();
	
	node = scene.instantiate();
	add_child(node);
