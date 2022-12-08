# ********************************
# MUST EXTEND THIS SCRIPT FOR STATE USE
# ********************************

# virtual base class for all States
class_name State
extends Node

signal entered # Signal emitted when this state is entered
signal exited # Signal emitted when this state is exited

# Parent state machine, can be a NestedState or StateMachine
var state_machine = null
var is_active = false
var cur_state = null

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	is_active = true
	emit_signal("entered")

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	is_active = false
	emit_signal("exited")
	
