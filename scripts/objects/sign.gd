extends StaticBody2D

@export_multiline var text: Array[String] = []

func interact() -> bool:
	if Game.player.direction != Vector2.UP:
		Dialog.say(["i can't read this sign from here."])
		return true
	Dialog.say(text)
	return true
