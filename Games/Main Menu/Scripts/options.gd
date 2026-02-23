extends Node2D

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Main_Menu.tscn")
