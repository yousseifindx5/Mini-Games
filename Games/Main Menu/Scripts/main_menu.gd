extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_1.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Options.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
