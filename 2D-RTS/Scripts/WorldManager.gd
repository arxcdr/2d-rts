extends Node2D

var selected_units = []

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	print("selected %s" % unit.name)

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	print("deselected %s" % unit.name)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
