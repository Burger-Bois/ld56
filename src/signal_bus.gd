extends Node


signal enemy_hit(enemy: Enemy)

signal player_health_changed(new_value: int)
signal player_dazed_changed(time_left: float, wait_time: float)

signal score_changed(new_value: int)
