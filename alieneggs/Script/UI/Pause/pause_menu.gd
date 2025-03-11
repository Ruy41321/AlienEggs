extends Control

var radarShader = null

			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if $MarginContainer/VBoxContainer/Resume.disabled == true || GlobalVariables.is_video_playing():
			return
		if !visible:
			show()
			get_tree().paused = 1
			radarShader.hide()
		else:
			hide()
			get_tree().paused = 0
			radarShader.show()

func _on_resume_pressed() -> void:
	get_tree().paused = 0
	radarShader.show()
	visible = 0

func _on_restart_pressed() -> void:
	if get_tree().paused == true:
		get_tree().paused = 0
	GlobalVariables.reset_globals()
	get_tree().reload_current_scene()

func _on_back_pressed() -> void:
	get_tree().paused = 0
	visible = 0
	get_tree().change_scene_to_file("res://Scene/UI/StartScreen/start_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
