extends Node2D

@onready var brickObject = preload("res://Games/Breakout/scenes/brick.tscn")

var columns = 32
var rows = 7 
var margin = 50 

func _ready() -> void:
	GameManager.show_ui()
	setupLevel()
	GameManager.update_ui()

func setupLevel():
	rows = 2 + GameManager.level
	if(rows > 9):
		rows = 9
	
	var colors = getColors()
	colors.shuffle()
	
	for r in rows:
		for c in columns:
			var randomNumber = randi_range(0,2)
			if randomNumber > 0:
				var newBrick = brickObject.instantiate()
				newBrick.add_to_group("Brick")
				add_child(newBrick)
				newBrick.get_node("Sprite2D").scale = Vector2(0.5,0.5)
				newBrick.position = Vector2(margin + (38 * c), margin + (38 * r))
				
				var sprite = newBrick.get_node('Sprite2D')
				if r >= 9:
					sprite.modulate = colors[0]
				elif r < 9 and r >= 6:
					sprite.modulate = colors[1]
				elif r < 6 and r >= 3:
					sprite.modulate = colors[2]
				else:
					sprite.modulate = colors[3]

func getColors():
	var colors = [
		Color( 0, 1, 1, 1 ),
		Color( 0.54, 0.17, 0.89, 1 ),
		Color( 0.68, 1, 0.18, 1 ),
		Color( 1,1,1, 1 )
	]
	
	return colors

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Main Menu/Scenes/Games_2.tscn")
	GameManager.hide_ui()
