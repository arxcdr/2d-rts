extends Camera2D

export var panSpeed = 10.0
export var speed = 19.0
export var zoomSpeed = 10.0
export var zoomMargin = 0.1

export var zoomMin = 0.5
export var zoomMax = 3.0
export var marginX = 200.0
export var marginY = 200.0

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var zoomPos = Vector2()
var zoomFactor = 1.0
var zooming = false
var is_dragging = false
var move_to_point = Vector2()

onready var rectd = $'../UI/Base/draw_rect'

signal area_selected
signal start_move_selection

func _ready():
	connect("area_selected", get_parent(), "area_selected", [self])
	connect("start_move_selection", get_parent(), "start_move_selection", [self])

func _process(delta):
	#smooth movement
	var inpx = (int(Input.is_action_pressed("ui_right"))
	 - int(Input.is_action_pressed("ui_left")))
	var inpy = (int(Input.is_action_pressed("ui_down"))
	 - int(Input.is_action_pressed("ui_up")))
	position.x = lerp(position.x, position.x + inpx * speed * zoom.x, speed * delta)
	position.y = lerp(position.y, position.y + inpy * speed * zoom.y, speed * delta)
	
	# Pan camera by dragging mouse to the sides while maintaining Ctrl key pressed
	if Input.is_key_pressed(KEY_CONTROL):
		#check mouse position
		if mousePos.x < marginX:
			position.x = lerp(position.x, position.x - abs(mousePos.x - marginX)/marginX * panSpeed * zoom.x, panSpeed * delta)
		elif mousePos.x > OS.window_size.x - marginX:
			position.x = lerp(position.x, position.x + abs(mousePos.x - OS.window_size.x + marginX)/marginX * panSpeed * zoom.x, panSpeed * delta)
		if mousePos.y < marginY:
			position.y = lerp(position.y, position.y - abs(mousePos.y - marginY)/marginY * panSpeed * zoom.y, panSpeed * delta)
		elif mousePos.y > OS.window_size.y - marginY:
			position.y = lerp(position.y, position.y + abs(mousePos.y - OS.window_size.y + marginY)/marginY * panSpeed * zoom.y, panSpeed * delta)
	
	if Input.is_action_just_pressed("ui_left_mouse_button"):
		start = mousePosGlobal
		startV = mousePos
		is_dragging = true
	
	if is_dragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
	
	if Input.is_action_just_released("ui_left_mouse_button"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			is_dragging = false
			draw_area(false)
	
	if Input.is_action_just_released("ui_right_mouse_button"):
		move_to_point = mousePosGlobal
		emit_signal("start_move_selection")
	
	#zoom in
	zoom.x = lerp(zoom.x, zoom.x * zoomFactor, zoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomFactor, zoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomFactor = 1.0

func draw_area(s = true):
	rectd.rect_size = Vector2(abs(startV.x-endV.x), abs(startV.y - endV.y))
	
	var pos = Vector2()
	pos.x = startV.x if (startV.x < endV.x) else endV.x
	pos.y = startV.y if (startV.y < endV.y) else endV.y
	pos.y -= OS.window_size.y
	rectd.rect_position = pos
	
	rectd.rect_size *= int(s) #true = 1 and false = 0

func _input(event):
	if event is InputEventMouseButton:
		zooming = true
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoomFactor -= 0.01 * zoomSpeed
				zoomPos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomFactor += 0.01 * zoomSpeed
				zoomPos = get_global_mouse_position()
		else:
			zooming = false
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()