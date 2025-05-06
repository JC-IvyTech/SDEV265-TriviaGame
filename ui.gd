extends CanvasLayer

# Updates the score counter.
func update_score(cat):
	$MarginContainer/Score.text = cat + " Score: " + str(Global.category_scores[cat])
