extends Weapon


export (int) var current_tier = 0

var weapon_tiers := [
  {
    "fire_rate": 0.3
  },
  {
    "fire_rate": 0.28
  },
  {
    "fire_rate": 0.26
  },
  {
    "fire_rate": 0.24
  },
  {
    "fire_rate": 0.22
  },
  {
    "fire_rate": 0.2
  },
  {
    "fire_rate": 0.18
  },
  {
    "fire_rate": 0.16
  },
  {
    "fire_rate": 0.14
  },
  {
    "fire_rate": 0.2
  },
]


func _ready():
  set_weapon_tier()


func set_weapon_tier():
  var weapon_tier = self.weapon_tiers[self.current_tier]

  self.projectile = self.projectiles[self.current_tier]
  self.fire_rate = weapon_tier['fire_rate']


func reset_tier():
  self.current_tier = 0


func increment_tier():
  if self.current_tier >= len(self.projectiles) - 1:
    return

  self.current_tier += 1
  set_weapon_tier()
