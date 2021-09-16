extends StaticBody

func _ready():
	print($Area.get_overlapping_areas())

func _process(delta):
	print($Area.get_overlapping_areas())
