# virtual base class for all State Machines
class_name StateMachine
extends Node

# default state
export(String) var default
# current state
var cur_state
const SUPRESSION_FRAMES = 2 # number of frames to supress state transition
var supress_transition = SUPRESSION_FRAMES

func _ready():
	cur_state = get_node(default)
	
	for child in get_children():
		child.state_machine = self
		
	cur_state.enter()
	
# Pass the physics update call to the current state
# Parent node responsible for calling physics update for state machine
func physics_update(delta):
	if supress_transition:
		supress_transition -= 1
	cur_state.physics_update(delta)

func transition_to(new_state: String, msg: Dictionary = {}):
	if not supress_transition:
		call_deferred("transtion_to", new_state, msg)

func transition_to_deferred(new_state: String, msg: Dictionary = {}):
	if not has_node(new_state):
		print(name + " has no child node " + new_state)
		return
	# exit the current state
	cur_state.exit()
	# select the new state and enter
	cur_state = get_node(new_state)
	cur_state.enter(msg)
	supress_transition = SUPRESSION_FRAMES
