extends CanvasLayer

const THE_BEGINNING: DialogueResource = preload("uid://didr77jtke0gt")
@export var animation_player: AnimationPlayer


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	animation_player.play("slide_in")
	animation_player.queue("idle")
	# wait for slide_in to finish
	await animation_player.animation_finished
	_show_dialogue()


func _show_dialogue() -> void:
	match GlobalState.unlocked_level:
		E.Level.Level1:
			DialogueManager.show_dialogue_balloon(THE_BEGINNING)
		_:
			printerr("Dialogue not configured for this level!")


func _on_dialogue_ended(_resource: DialogueResource) -> void:
	animation_player.stop()
	animation_player.play("slide_out")
	# wait for slide_out to finish
	await animation_player.animation_finished
	queue_free()
