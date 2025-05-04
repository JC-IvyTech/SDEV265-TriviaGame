extends Control

var questionid : int
var category = Global.category
var categories = Global.categories
var category_scores = Global.category_scores
var database : SQLite
var catid
var correct_answer : String
var feedback_sounds = {
	"click": preload("res://assets/sounds/click3.ogg"),
	"correct": preload("res://assets/sounds/Rise03.mp3"),
	"wrong": preload("res://assets/sounds/Downer01.mp3")
}

func _ready() -> void:
	$UI.update_score(category)
	catid = categories[category]
	database = SQLite.new()
	database.path = Global.db_path
	database.open_db()
	load_question()
	
# Load the final question from the DB.
func load_question():
	questionid = 10
	var select_condition : String = "id = " + str(questionid) + " and category_id = " + str(catid)
	var selected_array : Array = database.select_rows("questions", select_condition, ["question_text", "correct_answer"])
	print("condition: " + select_condition) # lets me cheat and see the correct answers in the console. (and also verfiy that they've loaded correctly)
	print("result: {0}".format([str(selected_array)]))
	correct_answer = selected_array[0]["correct_answer"].to_lower()
	display_question(selected_array[0]["question_text"])

#Displays the final question loaded from the DB.
func display_question(question):
	$CenterContainer/GridContainer/MarginContainer/Question.text = str(question)

#Checks the user answer when they hit submit.
func _on_submit_button_pressed() -> void:
	$FeedbackSound.stream = feedback_sounds["click"]
	$FeedbackSound.play()
	var user_answer = $CenterContainer/GridContainer/LineEdit.text.to_lower()
	await $FeedbackSound.finished
	if (user_answer == correct_answer):
		Global.increase_score()
		$FeedbackSound.stream = feedback_sounds["correct"]
		$FeedbackSound.play()
		await $FeedbackSound.finished
		$SceneTransitionRect.transition_to("res://menu.tscn")
	else:
		$CenterContainer/GridContainer/MarginContainer/Question.text = "Wrong answer, try the category again!"
		$FeedbackSound.stream = feedback_sounds["wrong"]
		$FeedbackSound.play()
		Global.final_failed()
		var query = "UPDATE questions SET answered = 0 WHERE category_id = " + str(catid) + ";"
		database.query(query)
		await $FeedbackSound.finished
		$SceneTransitionRect.transition_to("res://menu.tscn")
