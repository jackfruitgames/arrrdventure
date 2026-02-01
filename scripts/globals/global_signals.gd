extends Node

@warning_ignore_start("unused_signal")

# GAME
signal start_game()
signal start_level(level: E.Level)
signal finish_level(level: E.Level)
signal level_failed()
signal exit_game()

# ENEMY
signal enemy_died()
signal boss_spawned(element: E.Element)

# AUDIO
signal play_sound(sound: E.Sound)

# DIALOGUE
signal dialogue_ended()

@warning_ignore_restore("unused_signal")
