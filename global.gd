extends Node

var category
var category_scores = {"History": 0, "Science": 0, "Entertainment": 0, "ArtLit": 0, "Sports": 0 }
var categories = {"History": 1, "Science": 2, "Entertainment": 3, "ArtLit": 4, "Sports": 5}
var database : SQLite
var db_path = "res://questions.db"

# Starts a new game, resets the DB and scores.
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

func final_failed():
	category_scores[category] = 0
	
