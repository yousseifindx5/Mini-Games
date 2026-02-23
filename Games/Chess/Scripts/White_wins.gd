extends Control

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Chess/Scenes/main.tscn")

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_1.tscn")
