extends RigidBody2D


func hit():
	remove_from_group("Brick")
	GameManager.addPoints(1)
	GameManager.update_ui()
	
	$CPUParticles2D.emitting = true
	$Sprite2D.visible = false 
	$CollisionShape2D.set_deferred("disabled", true) 
	
	var bricksLeft = get_tree().get_nodes_in_group("Brick").size()
	
	if bricksLeft == 0:
		get_parent().get_node("Ball").is_active = false
		await get_tree().create_timer(1).timeout 
		GameManager.level += 1
		get_tree().call_deferred("reload_current_scene")
	else:
		await get_tree().create_timer(1).timeout
		queue_free()
