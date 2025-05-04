extends Control

# On scene load, calls the function to search the category scores to see if any categories should be marked as completed.
func _ready() -> void:
	search_categories()

# Searches the category scores to see if any have been completed, then calls disable_button to mark it as completed.
func search_categories():
	var total_score := 0
	for cat in Global.category_scores:
		var cat_score = Global.category_scores[cat]
		if (cat_score == 10):
			total_score += 1
			disable_button(cat)
			if (total_score == 5):
				you_win()

# Disables the buttons for completed categories, turning them green to mark them as completed.
func disable_button(cat):
	match cat:
		"History":
			$VBoxContainer/HFlowContainer/History/HistoryButton.disabled = true
		"Science":
			$VBoxContainer/HFlowContainer/Science/ScienceButton.disabled = true
		"Entertainment":
			$VBoxContainer/HFlowContainer/Entertainment/EntertainmentButton.disabled = true
		"ArtLit":
			$VBoxContainer/HFlowContainer/ArtLit/ArtLitButton.disabled = true
		"Sports":
			$VBoxContainer/HFlowContainer/Sports/SportsButton.disabled = true

# Called if all categories are completed. Hides everything else and displays the "You Win!" message.
func you_win():
	$VBoxContainer.hide()
	$WinMessage.show()

# The following functions are signals from the category buttons.
# They assign the chosen category to a global variable so the main scene knows which category to run.
func _on_history_button_pressed() -> void:
	$Click.play()
	await $Click.finished
	Global.category = "History"
	$SceneTransitionRect.transition_to("res://main.tscn")

func _on_science_button_pressed() -> void:
	$Click.play()
	await $Click.finished
	Global.category = "Science"
	$SceneTransitionRect.transition_to("res://main.tscn")


func _on_entertainment_button_pressed() -> void:
	$Click.play()
	await $Click.finished
	Global.category = "Entertainment"
	$SceneTransitionRect.transition_to("res://main.tscn")


func _on_art_lit_button_pressed() -> void:
	$Click.play()
	await $Click.finished
	Global.category = "ArtLit"
	$SceneTransitionRect.transition_to("res://main.tscn")


func _on_sports_button_pressed() -> void:
	$Click.play()
	await $Click.finished
	Global.category = "Sports"
	$SceneTransitionRect.transition_to("res://main.tscn")
