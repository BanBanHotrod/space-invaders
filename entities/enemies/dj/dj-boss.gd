extends Spatial


export (Array, PackedScene) var phases = []
export (float) var phase_attack_time = 10.0
export (float) var phase_wait_time = 5.0

var current_phase = 0
var attack_instance
var waiting := true


func _ready():
  print('boss ready')
  $Timer.wait_time = self.phase_wait_time
  $Timer.start()


func start_attack():
  print('start attack')
  self.attack_instance = self.phases[self.current_phase].instance()

  add_child(self.attack_instance)


func stop_attack():
  print('stop attack')
  self.attack_instance.queue_free()


func _on_Timer_timeout():
  print('timer event')
  $Timer.stop()

  if self.waiting:
    $Timer.wait_time = self.phase_attack_time
    $Timer.start()
    self.start_attack()
    self.waiting = false
  else:
    self.stop_attack()

    $Timer.wait_time = self.phase_wait_time
    self.current_phase += 1

    if self.current_phase >= len(self.phases):
      self.current_phase = 0

    $Timer.start()
    self.waiting = true
