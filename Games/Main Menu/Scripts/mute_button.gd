extends Button

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	pressed.connect(_button_pressed)
	
	call_deferred("_init_pivot")
	_update_button_text()

func _on_pressed():
	var is_muted = not AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, is_muted)
	
	_update_button_text()

func _update_button_text():
	if AudioServer.is_bus_mute(master_bus):
		text = "Un Mute Background Music"
	else:
		text = "Mute Background Music"

func _init_pivot() -> void:
	pivot_offset = size/2.0

func _button_enter() -> void:
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)

func _button_exit() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

func _button_pressed() -> void:
	var button_press_tween: Tween = create_tween()
	button_press_tween.tween_property(self, "scale", pressed_scale, 0.06).set_trans(Tween.TRANS_SINE)
	button_press_tween.tween_property(self, "scale", hover_scale, 0.12).set_trans(Tween.TRANS_SINE)
