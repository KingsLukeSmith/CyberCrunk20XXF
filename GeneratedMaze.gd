extends Spatial

var max_room_count = 15
var maze_complete = false
var q = []
var room_count = 0
var room_pieces = []
var current
var new_piece
var last_piece 


var pieces = [

	"res://BlenderExports/Caves/Cave_T_Intersection.tscn",


]
var cap = 	"res://BlenderExports/Caves/Cave_Cap.tscn"




func add_positions(q,piece):
	var child_nodes = piece.get_children()
	for child in child_nodes:
		if child.get_class() == "Position3D":
			print("adding node for",piece.name)
			q.append(child)

func _ready():
	reset()
		
func reset():
#	for child in get_children():
#		if not child.get_class() in ["Camera","Timer"]:
#			child.queue_free()
	randomize()
	#STARTING tile
	var entry = load(pieces[0]).instance()
	add_child(entry)
	#add_positions(q,entry)
	last_piece = entry
	room_count = 0
	q = []
	current = null
	maze_complete = false
	

				
			
func create_map():
	#check previous frame collisions
	if maze_complete:
		$Timer.queue_free()
		print(q.size())
		for empty in q:
			var endcap = load(cap).instance()
			endcap.global_transform = empty.global_transform
			add_child(endcap)
			
	
	if not maze_complete:
		if last_piece.get_node("Area").get_overlapping_areas().size()<=1:
			#print("no collisions, keeping")
			room_count+=1
			add_positions(q,last_piece) #add new position 3d
			if room_count >= max_room_count:
				print("done")
				maze_complete = true
				
		else:
			last_piece.queue_free()
			#print("found collisions, deleting")
			q.append(current) #push current 3d position back into q
			
		if not maze_complete:		
			current = q.pop_front()
			new_piece = load(pieces[randi()%len(pieces)]).instance()
			new_piece.global_transform = current.global_transform
			add_child(new_piece)
			last_piece = new_piece

		
		
	
	

	
func _on_Timer_timeout():
	print("time")
	create_map()
