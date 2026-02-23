extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var player : int
var moves : int
var winner : int
var temp_marker
var player_panel_pos : Vector2
var grid_data : Array
var grid_pos : Vector2i
var board_size : float
var cell_size : float
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int

func _ready():
	board_size = $Board.texture.get_width()
	cell_size = board_size / 3
	player_panel_pos = $PlayerPanel.position
	new_game()
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var local_pos = $Board.to_local(event.position)
			var offset_pos = local_pos + Vector2(board_size / 2, board_size / 2)
			
			if offset_pos.x >= 0 and offset_pos.x < board_size and offset_pos.y >= 0 and offset_pos.y < board_size:
				grid_pos = Vector2i(offset_pos / cell_size)
				
				if grid_pos.x >= 0 and grid_pos.x < 3 and grid_pos.y >= 0 and grid_pos.y < 3:
					if grid_data[grid_pos.y][grid_pos.x] == 0:
						moves += 1
						grid_data[grid_pos.y][grid_pos.x] = player
						
						var marker_local_pos = (Vector2(grid_pos) * cell_size) + Vector2(cell_size / 2, cell_size / 2) - Vector2(board_size / 2, board_size / 2)
						var marker_global_pos = $Board.to_global(marker_local_pos)
						
						create_marker(player, marker_global_pos)
						
						if check_win() != 0:
							get_tree().paused = true
							$GameOverMenu.show()
							if winner == 1:
								$GameOverMenu.get_node("ResultLabel").text = "O Wins!"
							elif winner == -1:
								$GameOverMenu.get_node("ResultLabel").text = "X Wins!"
						elif moves == 9:
							get_tree().paused = true
							$GameOverMenu.show()
							$GameOverMenu.get_node("ResultLabel").text = "It's a Tie!"
							
						player *= -1
						if temp_marker:
							temp_marker.queue_free()
						
						var panel_center = $PlayerPanel.global_position + ($PlayerPanel.size / 2)
						create_marker(player, panel_center, true)

func new_game():
	player = 1
	moves = 0
	winner = 0
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
		]
	row_sum = 0
	col_sum = 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	
	var panel_center = $PlayerPanel.global_position + ($PlayerPanel.size / 2)
	create_marker(player, panel_center, true)
	
	$GameOverMenu.hide()
	get_tree().paused = false

func create_marker(p_player, p_pos, temp=false):
	if p_player == 1:
		var circle = circle_scene.instantiate()
		circle.position = p_pos
		circle.scale = $Board.scale
		circle.add_to_group("circles")
		add_child(circle)
		if temp: temp_marker = circle
	else:
		var cross = cross_scene.instantiate()
		cross.position = p_pos
		cross.scale = $Board.scale
		cross.add_to_group("crosses")
		add_child(cross)
		if temp: temp_marker = cross

func check_win():
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
	
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner

func _on_game_over_menu_restart():
	new_game()


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_1.tscn")
