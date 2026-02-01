extends Node

var player_name := "Namenloser Held"
var unlocked_level: E.Level = E.Level.Level1

## Should be set by the level when the player dies.
## Is used and reset by the dialogue system to show the 'level failed' dialogue.
var player_died := false
