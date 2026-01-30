extends Node

@warning_ignore_start("unused_signal")

# GAME
signal start_game()
signal exit_game()

# AUDIO
signal play_click_sound()
signal play_sound(sound: E.Sound)

@warning_ignore_restore("unused_signal")
