extends Control

var questionid : int # the database id of the current question, set in the load_question() function, and used to mark that question as answered in the DB by answer_button()
var category = Global.category # copying the Global category variable, set by the menu scene.
var categories = Global.categories # copying the Global variable.
var category_scores = Global.category_scores # copying the Global variable.
var database : SQLite # the database
var catid # the ID of the current category.
var correct_answer_pos : int # the button assigned to the correct answer.
var feedback_sounds = {
	"click": preload("res://assets/sounds/click3.ogg"),
	"correct": preload("res://assets/sounds/Rise03.mp3"),
	"wrong": preload("res://assets/sounds/Downer01.mp3")
} # feedback sounds for button clicks and the correct/incorrect answer sounds.

# Update the score, get the category ID, open the DB, load a question.
# Repeats after every question as once a question is answered this scene reloads.
func _ready() -> void:
	$UI.update_score(category)
	catid = categories[category]
	database = SQLite.new()
	database.path = Global.db_path
	database.open_db()
	if (category_scores[category] < 9):
		load_question()

# Load a random question from the DB that has not been marked as answered. 
# If it pulls one that has been answered, it selects a new one
# until it finds one that hasn't been answered.
func load_question():
	questionid = randi_range(1, 9)
	var select_condition : String = "id = " + str(questionid) + " and category_id = " + str(catid)
	var selected_array : Array = database.select_rows("questions", select_condition, ["question_text", "correct_answer", "wrong_answer1", "wrong_answer2", "wrong_answer3", "answered"])
	print("condition: " + select_condition) # lets me cheat and see the correct answers in the console. (and also verfiy that they've loaded correctly)
	print("result: {0}".format([str(selected_array)]))
	if (selected_array[0]["answered"] == 1):
		load_question()
	else:
		display_question(selected_array)

# Displays the question loaded in the previous function on to the screen,
# then picks a random button to assign to the correct answer and saves it to a 
# variable that can be accessed in the following function.
func display_question(question):
	$CenterContainer/GridContainer/MarginContainer/Question.text = str(question[0]["question_text"])
	correct_answer_pos = randi_range(1, 4)
	match correct_answer_pos:
		1:
			$CenterContainer/GridContainer/Multichoice/Button1/Answer.text = question[0]["correct_answer"]
			$CenterContainer/GridContainer/Multichoice/Button2/Answer.text = question[0]["wrong_answer1"]
			$CenterContainer/GridContainer/Multichoice/Button3/Answer.text = question[0]["wrong_answer2"]
			$CenterContainer/GridContainer/Multichoice/Button4/Answer.text = question[0]["wrong_answer3"]
		2:
			$CenterContainer/GridContainer/Multichoice/Button2/Answer.text = question[0]["correct_answer"]
			$CenterContainer/GridContainer/Multichoice/Button1/Answer.text = question[0]["wrong_answer1"]
			$CenterContainer/GridContainer/Multichoice/Button3/Answer.text = question[0]["wrong_answer2"]
			$CenterContainer/GridContainer/Multichoice/Button4/Answer.text = question[0]["wrong_answer3"]
		3:
			$CenterContainer/GridContainer/Multichoice/Button3/Answer.text = question[0]["correct_answer"]
			$CenterContainer/GridContainer/Multichoice/Button1/Answer.text = question[0]["wrong_answer1"]
			$CenterContainer/GridContainer/Multichoice/Button2/Answer.text = question[0]["wrong_answer2"]
			$CenterContainer/GridContainer/Multichoice/Button4/Answer.text = question[0]["wrong_answer3"]
		4: 
			$CenterContainer/GridContainer/Multichoice/Button4/Answer.text = question[0]["correct_answer"]
			$CenterContainer/GridContainer/Multichoice/Button2/Answer.text = question[0]["wrong_answer1"]
			$CenterContainer/GridContainer/Multichoice/Button3/Answer.text = question[0]["wrong_answer2"]
			$CenterContainer/GridContainer/Multichoice/Button1/Answer.text = question[0]["wrong_answer3"]

# The signals below call this function with the number of button that was clicked.
# if the number of the button pressed matches the correct_answer_pos assigned above, the answer
# is correct and it marks the question as answered in the DB. 
# Feedback sounds are played for correct and incorrect answers, 
# then the scene reloads to get the next question.
func answer_button(num):
	toggle_buttons(true) # disable the buttons so the user can't click them when they're not supposed to.
	$FeedbackSound.stream = feedback_sounds["click"]
	$FeedbackSound.play()
	await $FeedbackSound.finished
	if (num == correct_answer_pos):
		Global.increase_score()
		var query = "UPDATE questions SET answered = 1 WHERE id = " + str(questionid) + " and category_id = " + str(catid) + ";" # DB query to set a question as answered so it won't be pulled again.
		database.query(query)
		$FeedbackSound.stream = feedback_sounds["correct"]
		$FeedbackSound.play()
		await $FeedbackSound.finished
	else:
		$FeedbackSound.stream = feedback_sounds["wrong"]
		$FeedbackSound.play()
		await $FeedbackSound.finished
	if (category_scores[category] == 9):
		$SceneTransitionRect.transition_to("res://final.tscn")
	else:
		$UIFade.play_backwards("fade")
		await $UIFade.animation_finished
		load_question()
		$UIFade.play("fade")
		await $UIFade.animation_finished
		toggle_buttons(false)
		$UI.update_score(category)

# Signals from the buttons.
func _on_button_1_pressed() -> void:
	answer_button(1)

func _on_button_2_pressed() -> void:
	answer_button(2)

func _on_button_3_pressed() -> void:
	answer_button(3)

func _on_button_4_pressed() -> void:
	answer_button(4)

# Toggle the buttons on or off.
func toggle_buttons(toggle):
	$CenterContainer/GridContainer/Multichoice/Button1.disabled = toggle
	$CenterContainer/GridContainer/Multichoice/Button2.disabled = toggle
	$CenterContainer/GridContainer/Multichoice/Button3.disabled = toggle
	$CenterContainer/GridContainer/Multichoice/Button4.disabled = toggle
