extends Control

# Initializes a new game at the title screen.
func _ready() -> void:
	Global.new_game()

# Plays the click feedback sound when the button is pressed.
# Then calls scene transition to transition to the menu.
func _on_new_game_button_pressed() -> void:
	$Click.play()
	await $Click.finished
	$AnimationPlayer.play_backwards("fade")
	$SceneTransitionRect.transition_to("res://menu.tscn")
