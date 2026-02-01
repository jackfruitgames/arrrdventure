extends CanvasLayer

@export var animation_player: AnimationPlayer

const THE_BEGINNING: DialogueResource = preload("uid://didr77jtke0gt")
const LEVEL_FAILED: DialogueResource = preload("uid://cmse78kbuu6qf")
const LEVEL_1_SUCCESS: DialogueResource = preload("uid://cajwygo8m480l")
const LEVEL_2_SUCCESS: DialogueResource = preload("uid://dddu0sj8rf3wp")
const LEVEL_3_SUCCESS: DialogueResource = preload("uid://df6puaosuhxpm")
const LEVEL_4_SUCCESS: DialogueResource = preload("uid://d1o7r2iwkhlna")
const THE_END: DialogueResource = preload("uid://cmyori7tg0fkg")
const THE_END_DEAD: DialogueResource = preload("uid://cpukmq1h3jdsh")


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	animation_player.play("slide_in")
	animation_player.queue("idle")
	# wait for slide_in to finish
	await animation_player.animation_finished
	_show_dialogue()


func _show_dialogue() -> void:
	if GlobalState.player_died:
		if GlobalState.unlocked_level == E.Level.Level5:
			GlobalState.unlocked_level = E.Level.End
			DialogueManager.show_dialogue_balloon(THE_END_DEAD)
		else:
			DialogueManager.show_dialogue_balloon(LEVEL_FAILED)
		GlobalState.player_died = false
		return

	match GlobalState.unlocked_level:
		E.Level.Level1:
			DialogueManager.show_dialogue_balloon(THE_BEGINNING)
		E.Level.Level2:
			DialogueManager.show_dialogue_balloon(LEVEL_1_SUCCESS)
		E.Level.Level3:
			DialogueManager.show_dialogue_balloon(LEVEL_2_SUCCESS)
		E.Level.Level4:
			DialogueManager.show_dialogue_balloon(LEVEL_3_SUCCESS)
		E.Level.Level5:
			DialogueManager.show_dialogue_balloon(LEVEL_4_SUCCESS)
		E.Level.End:
			DialogueManager.show_dialogue_balloon(THE_END)
		_:
			printerr("Dialogue not configured for this level!")


func _on_dialogue_ended(_resource: DialogueResource) -> void:
	animation_player.stop()
	animation_player.play("slide_out")
	# wait for slide_out to finish
	await animation_player.animation_finished
	GlobalSignals.dialogue_ended.emit()
	queue_free()
