extends Camera2D

export var speed = 19.0
export var zoomSpeed = 10.0
export var zoomMargin = 0.1
export var zoomMin = 0.5
export var zoomMax = 3.0

var zoomPos = Vector2()
var zoomFactor = 1.0
var zooming = false

func _ready():
	pass

func _process(delta):
	#smooth movement
	var inpx = (int(Input.is_action_pressed("ui_right"))
	 - int(Input.is_action_pressed("ui_left")))
	var inpy = (int(Input.is_action_pressed("ui_down"))
	 - int(Input.is_action_pressed("ui_up")))
	position.x = lerp(position.x, position.x + inpx * speed * zoom.x, speed * delta)
	position.y = lerp(position.y, position.y + inpy * speed * zoom.y, speed * delta)
	
	#zoom in
	zoom.x = lerp(zoom.x, zoom.x * zoomFactor, zoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomFactor, zoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomFactor = 1.0

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
			