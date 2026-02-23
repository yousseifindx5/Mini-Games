extends Control

func _on_left_arrow_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_1.tscn")

func _on_right_arrow_pressed() -> void:
	pass

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Main_Menu.tscn")


func _on_ping_pong_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Ping Pong/Scenes/main.tscn")
