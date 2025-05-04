extends ColorRect

# Just a reusable fade transition, loads whichever scene is chosen.
func transition_to(scene):
	$BlackFade.play_backwards("fade")
	await $BlackFade.animation_finished
	get_tree().change_scene_to_file(scene)
