extends Node2D

@onready var grid: GridContainer = $GridContainer
@onready var mistakes_label: Label = $MistakesLabel

var game_grid = []
var puzzle = []
var solution_grid = []
var solution_count = 0 

var mistakes = 0
const MAX_MISTAKES = 3

var selected_button: Vector2i = Vector2i(-1, -1)
var select_button_answer = 0

var is_notes_mode = false
const GRID_SIZE = 9

func _ready():
	bind_selectgrid_button_actions()
	bind_tool_buttons()
	init_game()

func init_game():
	mistakes = 0
	is_notes_mode = false
	_update_mistakes_ui()
	_create_empty_grid()
	_fill_grid(solution_grid) 
	_create_puzzle(Settings.DIFFICULTY)
	_populate_grid()

func _update_mistakes_ui():
	if mistakes_label:
		mistakes_label.text = "Mistakes: " + str(mistakes) + "/" + str(MAX_MISTAKES)

func _populate_grid():
	for child in grid.get_children():
		child.queue_free()
	
	game_grid = []
	for i in range(GRID_SIZE):
		var row = []
		for j in range(GRID_SIZE):
			row.append(create_button(Vector2i(i, j)))
		game_grid.append(row)

func create_button(pos: Vector2i):
	var row = pos.x
	var col = pos.y
	var ans = solution_grid[row][col]
	
	var button = Button.new()
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	if puzzle[row][col] != 0:
		button.text = str(puzzle[row][col])
		button.disabled = true
	
	button.set("theme_override_font_sizes/font_size", 32)
	button.custom_minimum_size = Vector2(52, 52)
	button.pressed.connect(_on_grid_button_pressed.bind(pos, ans))
	
	grid.add_child(button)
	return button

func _on_grid_button_pressed(pos: Vector2i, ans):
	selected_button = pos
	select_button_answer = ans

func bind_selectgrid_button_actions():
	for button in $SelectGrid.get_children():
		var b = button as Button
		b.pressed.connect(_on_selectgrid_button_pressed.bind(int(b.text)))

func bind_tool_buttons():
	if has_node("EraserButton"):
		$EraserButton.pressed.connect(_on_eraser_pressed)
	if has_node("NotesButton"):
		$NotesButton.pressed.connect(_on_notes_toggle_pressed)

func _on_eraser_pressed():
	if selected_button != Vector2i(-1, -1):
		var row = selected_button.x
		var col = selected_button.y
		if puzzle[row][col] == 0:
			var btn = game_grid[row][col] as Button
			btn.text = ""
			btn.set("theme_override_font_sizes/font_size", 32)

func _on_notes_toggle_pressed():
	is_notes_mode = !is_notes_mode
	var btn = $NotesButton as Button
	var lbl = btn.get_node_or_null("Label") as Label
	
	if is_notes_mode:
		btn.self_modulate = Color.WHITE
		btn.add_theme_color_override("icon_normal_color", Color.WHITE)
		if lbl:
			lbl.add_theme_color_override("font_color", Color.WHITE)
	else:
		btn.self_modulate = Color.BLACK
		btn.add_theme_color_override("icon_normal_color", Color.BLACK)
		if lbl:
			lbl.add_theme_color_override("font_color", Color.BLACK)

func _on_selectgrid_button_pressed(number_pressed):
	if selected_button != Vector2i(-1, -1):
		var row = selected_button.x
		var col = selected_button.y
		
		if puzzle[row][col] != 0:
			return
			
		var btn = game_grid[row][col] as Button
		
		if is_notes_mode:
			_handle_note_input(btn, number_pressed)
		else:
			_handle_normal_input(btn, number_pressed, row, col)

func _handle_note_input(btn: Button, num: int):
	btn.set("theme_override_font_sizes/font_size", 12)
	btn.set("theme_override_constants/line_spacing", -5)
	
	var notes = []
	for i in range(1, 10):
		if str(i) in btn.text or i == num:
			if str(i) in btn.text and i == num:
				continue
			notes.append(str(i))
	
	notes.sort()
	var final_text = ""
	for i in range(len(notes)):
		final_text += notes[i] + " "
		
	btn.text = final_text

func _handle_normal_input(btn: Button, num: int, row: int, col: int):
	btn.set("theme_override_font_sizes/font_size", 32)
	btn.text = str(num)
	
	var is_correct = (num == select_button_answer)
	var stylebox: StyleBoxFlat = btn.get_theme_stylebox("normal").duplicate(true)
	
	if is_correct:
		stylebox.bg_color = Color.SEA_GREEN
		btn.add_theme_stylebox_override("normal", stylebox)
		puzzle[row][col] = num
		_check_win_condition()
	else:
		stylebox.bg_color = Color.DARK_RED
		btn.add_theme_stylebox_override("normal", stylebox)
		_handle_mistake()

func _handle_mistake():
	mistakes += 1
	_update_mistakes_ui()
	if mistakes >= MAX_MISTAKES:
		get_tree().change_scene_to_file("res://Games/Sudoku/scenes/You lost.tscn")

func _check_win_condition():
	for r in range(GRID_SIZE):
		for c in range(GRID_SIZE):
			if puzzle[r][c] == 0:
				return
	
	get_tree().change_scene_to_file("res://Games/Sudoku/scenes/You win.tscn")

func _fill_grid(grid_obj):
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			if grid_obj[i][j] == 0:
				var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				numbers.shuffle()
				for num in numbers:
					if is_valid(grid_obj, i, j, num):
						grid_obj[i][j] = num
						if _fill_grid(grid_obj):
							return true
						grid_obj[i][j] = 0
				return false
	return true
			
func _create_empty_grid():
	solution_grid = []
	for i in range(GRID_SIZE):
		var row = []
		for j in range(GRID_SIZE):
			row.append(0)
		solution_grid.append(row)

func is_valid(grd, row, col, num):
	return (
		num not in grd[row] and 
		num not in get_column(grd, col) and 
		num not in get_subgrid(grd, row, col)
	)

func get_column(grd, col):
	var col_list = []
	for i in range(GRID_SIZE):
		col_list.append(grd[i][col])
	return col_list

func get_subgrid(grd, row, col):
	var subgrid = []
	var start_row = (row / 3) * 3
	var start_col = (col / 3) * 3
	for r in range(start_row, start_row + 3):
		for c in range(start_col, start_col + 3):
			subgrid.append(grd[r][c])
	return subgrid

func _create_puzzle(difficulty):
	puzzle = []
	for r in solution_grid:
		puzzle.append(r.duplicate())
		
	var removals = difficulty * 10 
	var attempts = 50
	while removals > 0 and attempts > 0:
		var row = randi() % 9
		var col = randi() % 9
		if puzzle[row][col] != 0:
			var temp = puzzle[row][col]
			puzzle[row][col] = 0
			if not has_unique_solution(puzzle):
				puzzle[row][col] = temp
				attempts -= 1
			else:
				removals -= 1

func has_unique_solution(puzzle_grid):
	solution_count = 0
	var grid_copy = []
	for r in puzzle_grid:
		grid_copy.append(r.duplicate())
	try_to_solve_grid(grid_copy)
	return solution_count == 1

func try_to_solve_grid(puzzle_grid):
	if solution_count > 1:
		return
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			if puzzle_grid[row][col] == 0:
				for num in range(1, 10):
					if is_valid(puzzle_grid, row, col, num):
						puzzle_grid[row][col] = num
						try_to_solve_grid(puzzle_grid)
						puzzle_grid[row][col] = 0
						if solution_count > 1:
							return
				return
	solution_count += 1

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_1.tscn")
