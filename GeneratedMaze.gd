extends Spatial

var max_room_count = 10

var pieces = [
	"res://TestCSG/Cap.tscn",
	"res://TestCSG/Hallway.tscn",
	"res://TestCSG/Intersection.tscn",
	"res://TestCSG/Hallway2.tscn"
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func add_positions(q,piece):
	var child_nodes = piece.get_children()
	for child in child_nodes:
		if child.get_class() == "Position3D":
			print("adding node for",piece.name)
			q.append(child)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#STARTING tile
	var entry = load(pieces[1]).instance()
	add_child(entry)
	
	#create an empty list and then add the exit from the entry tile to the q
	#to begin the process. 
	var q = []
	add_positions(q,entry)
	
	#reset the room counter, will only increment on a successful room placement
	var room_count = 0
	
	#repeat until all rooms places or not exits to place at
	while room_count < max_room_count and q.size() > 0:
		
		var current = q.pop_front()
		var new_piece = load(pieces[randi()%len(pieces)]).instance()
		print(new_piece.name)
		new_piece.global_transform = current.global_transform
		add_positions(q,new_piece)
		add_child(new_piece)
		room_count+=1
	
	for left_over in q:
		var new_cap = load(pieces[0]).instance()
		new_cap.global_transform = left_over.global_transform
		add_child(new_cap)
				
	#for each exit, add a new tile and add exits
		#check for collisions up to 3 times, then add a cap
	#until no exits


