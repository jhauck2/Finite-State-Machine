# virtual base class for all Nested States
# Similar to a State Machine but can be treated as a state
class_name NestedState
extends State

# default sub state
export(String) var default
var default_state = null
const SUPRESSION_FRAMES = 2 # number of frames to supress state transition
var supress_transition = SUPRESSION_FRAMES


func _ready():
	cur_state = get_node(default)
	default_state = cur_state
	
	for child in get_children():
		child.state_machine = self

# Will usually pass the physics update call to the current sub state
func physics_update(delta: float) -> void:
	if supress_transition:
		supress_transition -= 1
	cur_state.physics_update(delta)
	
func transition_to(new_state: String, msg: Dictionary = {}):
	if not supress_transition:
		call_deferred("transition_to_deferred", new_state, msg)

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
	
func enter(msg={}):
	.enter(msg)
	if msg.has("state"): # allows a transition to request a certain sub-state
		cur_state = get_node(msg["state"])
		msg.erase("state") # don't pass this state on in the message
	else:
		cur_state = default_state
	cur_state.enter(msg)
	supress_transition = SUPRESSION_FRAMES

func exit():
	cur_state.exit()
	.exit()
