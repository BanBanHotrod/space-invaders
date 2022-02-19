extends Control


signal announce_wave_completed


onready var label_wave = $MarginContainer/VBoxContainer/Wave
onready var label_title = $MarginContainer/VBoxContainer/Title
onready var margin_container = $MarginContainer
onready var tween = $Tween

var title_visible := false


func _ready():
  assert(margin_container != null)
  assert(label_wave != null)
  assert(label_title != null)
  assert(tween != null)


func announce_wave(wave_number, title):
  label_wave.text = "Wave " + str(wave_number)
  label_title.text = str(title)
  
  tween.interpolate_property(margin_container, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 7.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  tween.start()
  
  title_visible = true
  
  yield(tween, "tween_completed")
  
  tween.interpolate_property(margin_container, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  tween.start()
  
  title_visible = false

  yield(tween, "tween_completed")

  label_wave.text = ""
  label_title.text = ""
  
  emit_signal('announce_wave_completed')
