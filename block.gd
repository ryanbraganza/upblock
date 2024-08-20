extends RigidBody2D

class_name Block

signal settled(height: int, block: Block)
signal died()

var has_dropped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.gravity_scale = 0 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_sleeping_state_changed() -> void:
	if has_dropped and self.sleeping:
		print("sleeping & freezing at ", global_position.y)
		set_deferred('freeze', true)
		settled.emit(self.global_position.y, self)
		
func start_stretching() -> void:
	$AnimationPlayer.play("stretch")
	
func start_shifting() -> void:
	$AnimationPlayer.pause() # stop stretching
	$AnimationPlayer.play("shifting")

func drop() -> void:
	has_dropped = true
	$AnimationPlayer.pause()
	self.gravity_scale = 1

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body.collision_layer == 2:
		# floor is lava
		self.died.emit()
