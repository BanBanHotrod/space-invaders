extends Node


const SCORE_UNTIL_REWARD := 1000

var root
var total_lives := 4
var controls := true
var total_score := 0
var reward_progress := 0


signal root_initialized


func add_score(score):
  total_score += score
  reward_progress += score

  if reward_progress >= SCORE_UNTIL_REWARD:
    add_lives(1)
    reward_progress = 0
  
  self.root.find_node("UI").find_node("Score").text = str(total_score)
  
  
func add_lives(lives):
  total_lives += lives
  
  
signal set_stars_visibility(visible)
func set_stars_visibility(visible: bool):
  emit_signal('set_stars_visibility', visible)


signal set_stars_speed(speed)
func set_stars_speed(speed: float):
  emit_signal('set_stars_speed', speed)


signal set_stars_density(density)
func set_stars_density(density: float):
  emit_signal('set_stars_density', density)


func set_controls_enabled(enabled: bool):
  controls = enabled


signal blackout_level(time)
func blackout_level(time: int):
  emit_signal('blackout_level', time)


signal create_asteroid(count)
func create_asteroid(count: int):
  emit_signal('create_asteroid', count)
