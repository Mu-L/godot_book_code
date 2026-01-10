extends Node2D

@onready var polygon_2d_player: Polygon2D = $Player/Polygon2DPlayer
@onready var polygon_2d_menu: Polygon2D = $Player/Polygon2DMenu
@onready var area_2d: Area2D = $Player/Area2D
@onready var llmapi: LLMAPI = $LLMAPI
@onready var control: Control = $Player/Control
@onready var rich_text_label: RichTextLabel = $Player/Control/PanelContainer/VBoxContainer/RichTextLabel
@onready var line_edit: LineEdit = $Player/Control/PanelContainer/VBoxContainer/LineEdit

var window: Window 
var show_menu:bool = false
var dragging:bool = false
var drag_offset: Vector2i
var current_polygon : Polygon2D
var polygons :Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_window()
	line_edit.text_submitted.connect(on_submitted)
	llmapi.request_finished.connect(on_finished)
	area_2d.input_event.connect(on_input_event)
	control.scale = Vector2.ZERO
	polygons = [polygon_2d_player, polygon_2d_menu]
	current_polygon = polygons[int(show_menu)]

	
func _physics_process(delta: float) -> void:
	update_click_through()

func setup_window():
	window = get_window()
	window.size = DisplayServer.screen_get_size()
	
	
func update_click_through():
	var click_polygon: PackedVector2Array = current_polygon.polygon
	for vec_i in range(click_polygon.size()):
		click_polygon[vec_i] = current_polygon.to_global(click_polygon[vec_i])
	window.mouse_passthrough_polygon = click_polygon


func _input(event):
	if event.is_action_pressed("drag") and not dragging:
		dragging = true
		drag_offset = DisplayServer.mouse_get_position() - DisplayServer.window_get_position()

	elif event.is_action_released("drag") and dragging:
		dragging = false

	elif event is InputEventMouseMotion and dragging:
		var new_pos = DisplayServer.mouse_get_position() - drag_offset
		DisplayServer.window_set_position(new_pos)

	if event.is_action_pressed("quit"):
		get_tree().quit()


func on_input_event(viewport, event,shapeidx):
	if event.is_action_pressed("click") :
		show_menu = not show_menu
		toggle_menu(show_menu)

func toggle_menu(show:bool):
	var tw = create_tween()
	if show:
		current_polygon = polygons[int(show_menu)]
		update_click_through()
		tw.tween_property(control,"scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
		await tw.finished
		show_text("你好，我是小狐狸",0.5)
	else:
		tw.tween_property(control,"scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
		rich_text_label.visible_ratio=0
		await tw.finished
		current_polygon = polygons[int(show_menu)]
		update_click_through()


	

func show_text(text:String, time:float):
	rich_text_label.text = text
	var tw = create_tween()
	tw.tween_property(rich_text_label,"visible_ratio",1,time).from(0)


func on_submitted(new_text:String):
	llmapi.call_llm(new_text)
	line_edit.text = ""
	line_edit.editable = false
	show_text("让我想想",0.5)
	
func on_finished(output:String):
	line_edit.editable = true
	show_text(output,1)
