extends Node

const TOTAL_MINES : int = 20
var time_elapsed : float
var remaining_mines : int
var first_click : bool

func _ready():
	new_game()
	
func new_game():
	get_tree().paused = false
	first_click = true
	time_elapsed = 0
	remaining_mines = TOTAL_MINES
	
	if not $TileMap.end_game.is_connected(_on_tile_map_end_game):
		$TileMap.end_game.connect(_on_tile_map_end_game)
	if not $TileMap.game_won.is_connected(_on_tile_map_game_won):
		$TileMap.game_won.connect(_on_tile_map_game_won)
	if not $TileMap.flag_placed.is_connected(_on_tile_map_flag_placed):
		$TileMap.flag_placed.connect(_on_tile_map_flag_placed)
	if not $TileMap.flag_removed.is_connected(_on_tile_map_flag_removed):
		$TileMap.flag_removed.connect(_on_tile_map_flag_removed)
		
	$TileMap.new_game()

func _process(delta):
	time_elapsed += delta
	$HUD.get_node("Stopwatch").text = str(int(time_elapsed))
	$HUD.get_node("RemainingMines").text = str(remaining_mines)

func _on_tile_map_end_game():
	get_tree().change_scene_to_file("res://Games/MineSweeper/scenes/You Lost.tscn")

func _on_tile_map_game_won():
	get_tree().change_scene_to_file("res://Games/MineSweeper/scenes/You Win.tscn")

func _on_tile_map_flag_placed():
	remaining_mines -= 1

func _on_tile_map_flag_removed():
	remaining_mines += 1
	
func _on_game_over_restart():
	new_game()

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_1.tscn")
