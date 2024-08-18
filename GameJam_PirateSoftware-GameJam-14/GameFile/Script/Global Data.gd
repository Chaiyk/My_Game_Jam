extends Node

# game data
var game_start : bool = false
var pause_game : bool = false
var game_over : bool = false
var keys : int = 0

# player health data
var player_max_health : int = 100
var player_cur_health : int = 100
var first_time = false
# player corruption data
#20 minutes per game
#imagine 1/3 of the time is with torch
#torch should last 20/3 minutes
#corruption should go 0 > 100 in 20/3 * 2 ~ 13.33mins
var freeze_corruption_timer : bool = false

var max_darkness_timer : float = 15
var in_darkness_timer : float = 0

var corruption_time_in_seconds : float = 13 * 60
var max_flat_corruption_rate : float = 100 / corruption_time_in_seconds
var corruption_multiplier_rate : float = 1

var corruption_cur_level : float = 0
var corruption_max_level : float = 100

# player light data
var freeze_light_timer : bool = false

var default_light_timer_seconds : float = 600
var current_light_timer_seconds : float

var default_light_scale : float = 1.5
