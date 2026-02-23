extends Control

func _on_left_arrow_pressed() -> void:
	pass

func _on_right_arrow_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_2.tscn")

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Main_Menu.tscn")

func _on_chess_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Chess/Scenes/main.tscn")

func _on_sudoku_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Sudoku/scenes/Game.tscn")

func _on_tic_tac_toe_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Tic Tac Toe/Scenes/main.tscn")
