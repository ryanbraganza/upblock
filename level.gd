extends Node2D

var block: PackedScene = preload("res://block.tscn")
@onready var camera = $Camera2D
@onready var ui: UI = $UI

var height: int = 0

enum BlockState { IDLE, STRETCHING, SHIFTING, DROPPING, GAME_END }
var state: BlockState = BlockState.IDLE
var current_block: Block = null

var start_time_ms: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_time_ms = Time.get_ticks_msec()	
	$UI.set_time(start_time_ms)
	get_tree().create_timer(60).timeout.connect(time_out)	

func _input(event: InputEvent) -> void:
	if state == BlockState.IDLE and event.is_action_pressed("ui_accept"):
		state = BlockState.STRETCHING
		current_block = block.instantiate()
		current_block.global_position = Vector2(0, height - 200) # block height
		current_block.connect('settled', block_settled, ConnectFlags.CONNECT_ONE_SHOT)
		current_block.connect('died', block_died, ConnectFlags.CONNECT_ONE_SHOT)
		current_block.start_stretching()
		$blocks.add_child(current_block)
	elif state == BlockState.STRETCHING and event.is_action_released("ui_accept"):
		state = BlockState.SHIFTING
		current_block.start_shifting()
	elif state == BlockState.SHIFTING and event.is_action_pressed("ui_accept"):
		state = BlockState.DROPPING
		current_block.drop()
		current_block = null
	elif state == BlockState.GAME_END and event.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()

func block_settled(settled_height: int, block: Block) -> void:
	if state == BlockState.GAME_END:
		return
	self.height = min(self.height, settled_height)
	camera.global_position = Vector2(0, self.height)
	state = BlockState.IDLE
	
func time_out() -> void:
	state = BlockState.GAME_END
	if current_block:
		current_block.queue_free()
		current_block = null
	ui.end_game('time', height)
	
func block_died() -> void:
	print('block died')
	state = BlockState.GAME_END
	if current_block:
		current_block.queue_free()
		current_block = null
	ui.end_game('died', height)
