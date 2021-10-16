extends Weapon


export (int) var tier = 0
export (Array, PackedScene) var projectiles = []

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
  var weapon_tier = self.weapon_tiers[self.tier]

  self.projectile = self.projectiles[self.tier]
  self.fire_rate = weapon_tier['fire_rate']


func reset_tier():
  self.tier = 0


func increment_tier():
  if self.tier >= len(self.projectiles) - 1:
    return

  self.tier += 1
  set_weapon_tier()
