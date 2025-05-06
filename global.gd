extends Node

var category # the category chosen by the user in the menu scene
var category_scores = {"History": 0, "Science": 0, "Entertainment": 0, "ArtLit": 0, "Sports": 0 } # the user's score for each category
var categories = {"History": 1, "Science": 2, "Entertainment": 3, "ArtLit": 4, "Sports": 5} # dictionary of categories and their ID numbers
var database : SQLite # the database
var db_path = "res://questions.db" # the path to the database

# Starts a new game, resets the answered column in the DB and the scores.
func new_game():
	for cat in category_scores:
		category_scores[cat] = 0
	database = SQLite.new()
	database.path = db_path
	database.open_db()
	database.query("UPDATE questions SET answered = 0;")
	database.close_db()

# Increments the score for the current category.
func increase_score():
	category_scores[category] += 1

# If the user has failed the final question, this function is called to reset the score for that category.
# So the user will have to restart that category and try again.
func final_failed():
	category_scores[category] = 0
	
