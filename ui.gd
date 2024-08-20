extends CanvasLayer
class_name UI

var end_time: float = 0
var is_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		var current_time = Time.get_ticks_msec()
		var remaining_s = (end_time - current_time) / 1000
		$RichTextLabel.text = '[right]%.2f[/right]' % remaining_s

func set_time(time: float) -> void:
	print("time", time)
	end_time = time + 60_000
	is_running = true

func end_game(cause_of_end: String, height: float) -> void:
	is_running = false
	var score: float = abs(height)
	if cause_of_end == 'died':
		$RichTextLabel.text = '[right]You died! Your score was %s[/right]' % score
	elif cause_of_end == 'time':
		$RichTextLabel.text = '[right]Time is up! Your score was %s[/right]' % score

		
