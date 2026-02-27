extends Node

var score = 0 
var level = 1

func _ready():
	hide_ui()

func addPoints(points):
	score += points

func update_ui():
	var score_label = get_tree().root.find_child("ScoreLabel", true, false)
	var level_label = get_tree().root.find_child("LevelLabel", true, false)
	
	if score_label:
		score_label.text = "Score: " + str(score)
	if level_label:
		level_label.text = "Level: " + str(level)

func show_ui():
	var canvas = find_child("CanvasLayer", true, false)
	if canvas:
		canvas.visible = true

func hide_ui():
	var canvas = find_child("CanvasLayer", true, false)
	if canvas:
		canvas.visible = false
