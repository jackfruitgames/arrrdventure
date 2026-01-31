extends Node

@warning_ignore_start("unused_signal")

# GAME
signal start_game()
signal start_level(level: E.Level)
signal finish_level(level: E.Level)
signal exit_game()

# ENEMY
signal enemy_died()

# AUDIO
signal play_sound(sound: E.Sound)

@warning_ignore_restore("unused_signal")
