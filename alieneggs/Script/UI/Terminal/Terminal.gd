extends Control

@onready var terminal_eggs_text = $Screen/VBox/EggStatus
@onready var terminal_enemy_text = $Screen/VBox/EnemyStatus
@onready var terminal_supportItem_text = $Screen/VBox/SupportItem
@onready var terminal_goal_text: RichTextLabel = $Screen/VBox/Goal

var root_node

var is_enemy_in_sound = false
var is_enemy_in_radar = false
var is_enemy_in_noise = false

var eggs_has_arised = false

var font
var font_size = 30  # Default font size
var elapsed_time = 0
var last_notification = 0

# Add method to change font size
func set_font_size(new_size: int) -> void:
	font_size = new_size
	font.fixed_size = font_size
	# Reapply font to all terminal elements
	setup_terminal_text(terminal_eggs_text)
	setup_terminal_text(terminal_enemy_text)
	setup_terminal_text(terminal_supportItem_text)
	setup_terminal_text(terminal_goal_text)

func _process(_delta: float) -> void:
	elapsed_time += _delta
	if GlobalVariables.is_mother_mode():
		return
	var text
	if !eggs_has_arised:
		terminal_goal_text.add_theme_color_override("default_color", Color(0, 1, 0))
		text = "Find and destroy all the eggs before they'll be born: "\
			+str(int(root_node.play_time.time_left) - (int(root_node.play_time.wait_time)/2.0)) + \
			"\n   Eggs Remaining: " + str(GlobalVariables.eggs_number)
	else:
		terminal_goal_text.add_theme_color_override("default_color", Color(1, 0, 0))
		text = "The eggs has born, Run from the alien till the rescue arrives: "\
		+ str(int(root_node.play_time.time_left))
	update_goal_terminal(text, false)

func notify():
	if elapsed_time - last_notification <= 0.5:
		return
	$Notification.play()
	last_notification = elapsed_time

func setup_terminal() -> void:
	font = FontFile.new()
	font.fixed_size = font_size
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf")
	
	setup_terminal_text(terminal_eggs_text)
	setup_terminal_text(terminal_enemy_text)
	setup_terminal_text(terminal_supportItem_text)
	setup_terminal_text(terminal_goal_text)
	
	show_info_standard()
	show_goal()
	
func setup_terminal_text(textLabel):
	textLabel.clear()
	
	textLabel.add_theme_color_override("default_color", Color(0, 1, 0)) # Terminal green
	textLabel.add_theme_color_override("default_bg_color", Color(0, 0, 0)) # Black background
	textLabel.add_theme_font_override("default_font", font)
	
func update_eggs_terminal(message: String) -> void:
	terminal_eggs_text.clear()
	terminal_eggs_text.add_text(message)
	
func update_enemy_terminal(message: String) -> void:
	terminal_enemy_text.clear()
	terminal_enemy_text.add_text(message)
	notify()

func update_supportItem_terminal(message: String) -> void:
	terminal_supportItem_text.clear()
	terminal_supportItem_text.add_text(message)
	notify()

func update_goal_terminal(message: String, to_notify = true) -> void:
	terminal_goal_text.clear()
	terminal_goal_text.add_text(message)
	if to_notify:
		notify()

func show_goal():
	var text
	
	terminal_goal_text.add_theme_color_override("default_color", Color(0, 1, 0))
	text = "Find and destroy all the eggs:\n   Eggs Remaining: " + str(GlobalVariables.eggs_number)
	update_goal_terminal(text, false)

func show_info_standard():
	var text
	
	terminal_supportItem_text.add_theme_color_override("default_color", Color(1, 1, 0))
	text ="Press Space to throw a bomb\nto stun the Alien when it's close"
	update_supportItem_terminal(text)

func update_egg() -> void:
	show_goal()

func display_lose_text():
	terminal_enemy_text.clear()
	terminal_supportItem_text.clear()
	terminal_goal_text.clear()
	terminal_goal_text.add_theme_color_override("default_color", Color(1, 0, 0))
	update_goal_terminal(" GAME OVER: The Alien Mother has killed you!", false)

func display_win_text():
	terminal_enemy_text.clear()
	terminal_supportItem_text.clear()
	terminal_goal_text.clear()
	terminal_goal_text.add_theme_color_override("default_color", Color(0, 1, 0))
	update_goal_terminal(" YOU WON: The rescue has arrived", false)

func enemy_in_sound():
	is_enemy_in_sound = true
	terminal_enemy_text.add_theme_color_override("default_color", Color(1, 0, 0))
	var text = "Watch-out the enemy is near don't make too much noise"
	update_enemy_terminal(text)
	
func enemy_out_sound():
	is_enemy_in_sound = false
	terminal_enemy_text.add_theme_color_override("default_color", Color(0, 1, 0))
	var text = "The enemy is far enough to move freely"
	update_enemy_terminal(text)
	show_enemy_status_after_exit()

func enemy_in_radar():
	is_enemy_in_radar = true
	terminal_enemy_text.add_theme_color_override("default_color", Color(1, 0, 0))
	var text = "RUN THE ENEMY KNOWS YOUR POSITION"
	update_enemy_terminal(text)
	
func enemy_out_radar():
	is_enemy_in_radar = false
	terminal_enemy_text.add_theme_color_override("default_color", Color(0, 1, 0))
	var text = "The enemy can't detect you anymore"
	update_enemy_terminal(text)
	show_enemy_status_after_exit()
	
func enemy_in_noise():
	is_enemy_in_noise = true
	terminal_enemy_text.add_theme_color_override("default_color", Color(1, 0, 0))
	var text = "THE ENEMY CAN HEAR YOU AND IS CHASING YOU"
	update_enemy_terminal(text)
	
func enemy_out_noise():
	is_enemy_in_noise = false
	terminal_enemy_text.add_theme_color_override("default_color", Color(0, 1, 0))
	var text = "The enemy can't hear you anymore"
	update_enemy_terminal(text)
	show_enemy_status_after_exit()

func show_enemy_status_after_exit():
	if is_enemy_in_radar:
		enemy_in_radar()
	if is_enemy_in_noise:
		enemy_in_noise()
	if is_enemy_in_sound:
		enemy_in_sound()
		
func eggs_arised():
	eggs_has_arised = true
	
func update_bombs():
	if GlobalVariables.stun_bombs == 2:
		$HBoxContainer/Bomb3.hide()
	if GlobalVariables.stun_bombs == 1:
		$HBoxContainer/Bomb2.hide()
	if GlobalVariables.stun_bombs == 0:
		$HBoxContainer/Bomb1.hide()
