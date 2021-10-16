extends Spatial


export (int) var width = 6
export (int) var height = 4
export (float) var column_gap = 0.0
export (float) var row_gap = 0.0
export (PackedScene) var enemy_scene
export (int) var number_of_power_ups = 1

var total_enemies := 0
var power_up_used := false
var enemy_drops := []
var weapon_upgrade := load("res://entities/power_ups/weapon_upgrade/WeaponUpgrade.tscn")


signal wave_cleared(wave)


func _ready():
  self.total_enemies = self.width * self.height
  # TODO: separate enemy formation generation from wave instance
  self.instanciate_enemies()
  self.randomize_drops()


func randomize_drops():
  for _enemy in range(self.total_enemies):
    self.enemy_drops.append(false)

  for _power_up in range(self.number_of_power_ups):
    while true:
      var random_enemy = randi() % self.total_enemies

      if not self.enemy_drops[random_enemy]:
        self.enemy_drops[random_enemy] = true

        break


func instanciate_enemies() -> void:
  # TODO: make wave perfectly centered (off by half the gap distance)
  var half_width = (width + (width - 1) * (row_gap - 1)) / 2
  var half_height = (height + (height - 1) * (column_gap - 1)) / 2

  if self.enemy_scene != null:
    for x in range(self.width):
      for y in range(self.height):
        var enemy_instance = enemy_scene.instance()

        if not enemy_instance.is_class('Spatial'):
          return;

        var offset_x = x * row_gap - half_width
        var offset_y = y * column_gap - half_height

        enemy_instance.translation = Vector3(offset_x, offset_y, 0)
        enemy_instance.connect("enemy_destroyed", self, "_on_enemy_destroyed")
        $Enemies.add_child(enemy_instance)


func _on_enemy_destroyed(enemy):
  self.total_enemies -= 1

  if self.enemy_drops[self.total_enemies]:
    var weapon_upgrade_instance = self.weapon_upgrade.instance()
    weapon_upgrade_instance.global_transform = enemy.global_transform
    Global.root.add_child(weapon_upgrade_instance)

  enemy.queue_free()

  if self.total_enemies <= 0:
    emit_signal("wave_cleared", self)
