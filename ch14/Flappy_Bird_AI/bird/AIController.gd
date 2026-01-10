extends AIController2D

var move_action :int = 0


func get_obs() -> Dictionary:
	var obs = _player.sensors.get_observation()
	var player_speed = _player.velocity.y/_player.max_speed
	obs.append(player_speed)
	return {"obs": obs}


func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 2,
			"action_type": "discrete"
		},
	}
	
func set_action(action) -> void:	
	move_action = action["move_action"]
