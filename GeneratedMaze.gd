extends Spatial

var max_room_count = 30
var maze_complete = false
var q = []
var room_count = 0
var room_pieces = []
var current
var new_piece
var last_piece 


var pieces = [
	"res://BlenderExports/CornerLeft.tscn",
	"res://BlenderExports/DownStairs.tscn",
	"res://BlenderExports/Hall.tscn",
	"res://BlenderExports/Intersection.tscn",
	"res://BlenderExports/TallRoom.tscn"
]





func add_positions(q,piece):
	var child_nodes = piece.get_children()
	for child in child_nodes:
		if child.get_class() == "Position3D":
			#print("adding node for",piece.name)
			q.append(child)

func _ready():
	reset()
		
func reset():
	for child in get_children():
		if child.get_class()!= "Camera":
			child.queue_free()
	randomize()
	#STARTING tile
	var entry = load(pieces[0]).instance()
	add_child(entry)
	add_positions(q,entry)
	room_pieces.append(entry)
	last_piece = entry
	room_count = 0
	q = []
	current = null
	maze_complete = false
	
#	while room_count < max_room_count and q.size() > 0:
#
#		var current = q.pop_front()
#
#		var new_piece = load(pieces[randi()%len(pieces)]).instance()
#		#print(new_piece.name)
#		new_piece.global_transform = current.global_transform
#		add_positions(q,new_piece)
#		add_child(new_piece)
#
#		#check if bodies overlap
#		print(new_piece.get_node("Area").get_overlapping_bodies())
#		if new_piece.get_node("Area").get_overlapping_bodies().size() == 0:
#			room_count+=1
#		else:
#			#print("collision")
#			new_piece.queue_free()
#			q.append(current)
				
			
func _physics_process(delta):
	yield(get_tree(), "idle_frame")
	#check previous frame collisions
	if not maze_complete:
		
		if last_piece.get_node("Area").get_overlapping_areas().size()==0:
			print("no collisions, keeping")
			room_count+=1
			add_positions(q,last_piece) #add new position 3d
		else:
			last_piece.queue_free()
			print("found collisions, deleting")
			q.append(current) #push current 3d position back into q
			
				
		current = q.pop_front()
		new_piece = load(pieces[randi()%len(pieces)]).instance()
		new_piece.global_transform = current.global_transform
		add_child(new_piece)
		last_piece = new_piece

		
		if room_count > max_room_count:
			print("done")
			maze_complete = true
	
	if maze_complete:
		for child in get_children():
			if child.get_class()=="StaticBody":
				print(child.get_node("Area").get_overlapping_areas().size()	)
		set_physics_process(false)

	if Input.is_action_just_pressed("ui_accept"):
		reset()
	
	


