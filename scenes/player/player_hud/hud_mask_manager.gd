extends VBoxContainer

@export var mask1: Control
@export var mask2: Control
@export var mask3: Control
@export var mask4: Control
@export var mask5: Control


func _ready() -> void:
	set_mask_state()
	GlobalSignals.start_level.connect(set_mask_state)


func set_mask_state() -> void:
	assert(mask1 != null, "pls mask1")
	assert(mask2 != null, "pls mask2")
	assert(mask3 != null, "pls mask3")
	assert(mask4 != null, "pls mask4")
	assert(mask5 != null, "pls mask5")
	mask1.hide()
	mask2.hide()
	mask3.hide()
	mask4.hide()
	mask5.hide()
	print("Mask... " + str(GlobalState.unlocked_level))
	match GlobalState.unlocked_level:
		E.Level.Level1:
			mask1.show()
		E.Level.Level2:
			mask2.show()
		E.Level.Level3:
			mask3.show()
		E.Level.Level4:
			mask4.show()
		E.Level.Level5:
			mask5.show()
